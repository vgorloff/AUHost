import * as Path from 'path';
import * as WL from "wl-scripting";

class Project extends WL.AbstractProject {

   private projectFilePath: string;

   constructor(projectDirPath: string) {
      super(projectDirPath)
      this.projectFilePath = Path.join(this.projectDirPath, "Attenuator.xcodeproj")
   }

   actions() {
      return ["ci", "build", "clean", "test", "release", "verify", "deploy", "archive"]
   }

   build() {
      let b = new WL.XcodeBuilder(this.projectFilePath)
      b.build("AUHost-macOS")
      b.build("Attenuator-macOS")
   }

   clean() {
      WL.FileSystem.rmdirIfExists("/tmp/Attenuator.dst")
      WL.FileSystem.rmdirIfExists(`${this.projectDirPath}/DerivedData`)
      WL.FileSystem.rmdirIfExists(`${this.projectDirPath}/Build`)
   }

   ci() {
      let b = new WL.XcodeBuilder(this.projectFilePath)
      b.ci("AUHost-macOS")
      b.ci("Attenuator-macOS")
   }

}
