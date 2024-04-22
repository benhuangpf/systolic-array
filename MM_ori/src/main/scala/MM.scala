package MM

import chisel3._
import chisel3.util._
import chisel3.experimental.{IntParam, BaseModule}
import freechips.rocketchip.amba.axi4._
import freechips.rocketchip.subsystem.BaseSubsystem
import org.chipsalliance.cde.config.{Parameters, Field, Config}
import freechips.rocketchip.diplomacy._
import freechips.rocketchip.regmapper.{HasRegMap, RegField}
import freechips.rocketchip.tilelink._
import freechips.rocketchip.util.UIntIsOneOf

// DOC include start: GCD params
case class MMParams(
  address: BigInt = 0x4000,
  width: Int = 32,
  useAXI4: Boolean = false,
  useBlackBox: Boolean = true)
// DOC include end: GCD params

// DOC include start: GCD key
case object MMKey extends Field[Option[MMParams]](None)
// DOC include end: GCD key

class MMIO(val w: Int) extends Bundle {
  val clock = Input(Clock())
  val reset = Input(Bool())
  val input_ready = Output(Bool())
  val input_valid = Input(Bool())
  val a = Input(UInt(w.W))
  val b = Input(UInt(w.W))
  val output_ready = Input(Bool())
  val output_valid = Output(Bool())
  val res = Output(UInt(w.W))
  // val busy = Output(Bool())
}

// trait MMTopIO extends Bundle {
//   val mm_busy = Output(Bool())
// }

trait HasMMIO extends BaseModule {
  val w: Int
  val io = IO(new MMIO(w))
}

// DOC include start: GCD blackbox
class MMMMIOBlackBox(val w: Int) extends BlackBox(Map("WIDTH" -> IntParam(w))) with HasBlackBoxResource
  with HasMMIO
{
  addResource("/vsrc/MMMMIOBlackBox.v")
}
// DOC include end: GCD blackbox

// DOC include start: GCD chisel
// class GCDMMIOChiselModule(val w: Int) extends Module
//   with HasGCDIO
// {
//   val s_idle :: s_run :: s_done :: Nil = Enum(3)

//   val state = RegInit(s_idle)
//   val tmp   = Reg(UInt(w.W))
//   val gcd   = Reg(UInt(w.W))

//   io.input_ready := state === s_idle
//   io.output_valid := state === s_done
//   io.gcd := gcd

//   when (state === s_idle && io.input_valid) {
//     state := s_run
//   } .elsewhen (state === s_run && tmp === 0.U) {
//     state := s_done
//   } .elsewhen (state === s_done && io.output_ready) {
//     state := s_idle
//   }

//   when (state === s_idle && io.input_valid) {
//     gcd := io.x
//     tmp := io.y
//   } .elsewhen (state === s_run) {
//     when (gcd > tmp) {
//       gcd := gcd - tmp
//     } .otherwise {
//       tmp := tmp - gcd
//     }
//   }

//   io.busy := state =/= s_idle
// }
// DOC include end: GCD chisel

// DOC include start: GCD instance regmap

trait MMModule extends HasRegMap {
  // val io: MMTopIO

  implicit val p: Parameters
  def params: MMParams
  val clock: Clock
  val reset: Reset


  // How many clock cycles in a PWM cycle?
  val a = Reg(UInt(params.width.W))
  val b = Wire(new DecoupledIO(UInt(params.width.W)))
  val res = Wire(new DecoupledIO(UInt(params.width.W)))
  val status = Wire(UInt(2.W))

  // val impl = if (params.useBlackBox) {
  //   Module(new MMMMIOBlackBox(params.width))
  // } else {
  //   Module(new GCDMMIOChiselModule(params.width))
  // }

  val impl = Module(new MMMMIOBlackBox(params.width))

  impl.io.clock := clock
  impl.io.reset := reset.asBool

  impl.io.a := a
  impl.io.b := b.bits
  impl.io.input_valid := b.valid
  b.ready := impl.io.input_ready

  res.bits := impl.io.res
  res.valid := impl.io.output_valid
  impl.io.output_ready := res.ready

  status := Cat(impl.io.input_ready, impl.io.output_valid)
  // io.gcd_busy := impl.io.busy

  regmap(
    0x00 -> Seq(
      RegField.r(2, status)), // a read-only register capturing current status
    0x04 -> Seq(
      RegField.w(params.width, a)), // a plain, write-only register
    0x08 -> Seq(
      RegField.w(params.width, b)), // write-only, y.valid is set on write
    0x0C -> Seq(
      RegField.r(params.width, res))) // read-only, gcd.ready is set on read
}
// DOC include end: GCD instance regmap

// DOC include start: GCD router
class MMTL(params: MMParams, beatBytes: Int)(implicit p: Parameters)
  extends TLRegisterRouter(
    params.address, "mm", Seq("ucbbar,mm"),
    beatBytes = beatBytes)(
      new TLRegBundle(params, _))(
      // new TLRegBundle(params, _) with MMTopIO)(
      new TLRegModule(params, _, _) with MMModule)

class MMAXI4(params: MMParams, beatBytes: Int)(implicit p: Parameters)
  extends AXI4RegisterRouter(
    params.address,
    beatBytes=beatBytes)(
      new AXI4RegBundle(params, _))(
      // new AXI4RegBundle(params, _) with MMTopIO)(
      new AXI4RegModule(params, _, _) with MMModule)
// DOC include end: GCD router

// DOC include start: GCD lazy trait
trait CanHavePeripheryMM { this: BaseSubsystem =>
  private val portName = "mm"

  // Only build if we are using the TL (nonAXI4) version
  val mm_busy = p(MMKey) match {
    case Some(params) => {
      val mm = if (params.useAXI4) {
        val mm = pbus { LazyModule(new MMAXI4(params, pbus.beatBytes)(p)) }
        pbus.coupleTo(portName) {
          mm.node :=
          AXI4Buffer () :=
          TLToAXI4 () :=
          // toVariableWidthSlave doesn't use holdFirstDeny, which TLToAXI4() needsx
          TLFragmenter(pbus.beatBytes, pbus.blockBytes, holdFirstDeny = true) := _
        }
        mm
      } else {
        val mm = pbus { LazyModule(new MMTL(params, pbus.beatBytes)(p)) }
        pbus.coupleTo(portName) { mm.node := TLFragmenter(pbus.beatBytes, pbus.blockBytes) := _ }
        mm
      }
      // val pbus_io = pbus { InModuleBody {
      //   val busy = IO(Output(Bool()))
      //   busy := gcd.module.io.gcd_busy
      //   busy
      // }}
      // val gcd_busy = InModuleBody {
      //   val busy = IO(Output(Bool())).suggestName("gcd_busy")
      //   busy := pbus_io
      //   busy
      // }
      // Some(gcd_busy)
    }
    case None => None
  }
}
// DOC include end: GCD lazy trait

// DOC include start: GCD config fragment
class WithMM(useAXI4: Boolean = false, useBlackBox: Boolean = false) extends Config((site, here, up) => {
  case MMKey => Some(MMParams(useAXI4 = useAXI4, useBlackBox = useBlackBox))
})
// DOC include end: GCD config fragment
