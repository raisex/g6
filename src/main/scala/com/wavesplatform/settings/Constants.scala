package com.wavesplatform.settings

import com.wavesplatform.Version
import com.wavesplatform.utils.ScorexLogging

/**
  * System constants here.
  */
object Constants extends ScorexLogging {
  val ApplicationName = "FLG"
  val AgentName       = s"FLG v${Version.VersionString}"

  val UnitsInWave = 100000000L
  val TotalWaves  = 100000000L

}
