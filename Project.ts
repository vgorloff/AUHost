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
      console.log(this.projectFilePath)
   }

}
