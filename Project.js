const Path = require('path');
const AbstractProject = require('wl-scripting').AbstractProject;
const XcodeBuilder = require('wl-scripting').XcodeBuilder;
const FileSystem = require('wl-scripting').FileSystem;

class Project extends AbstractProject {
   constructor(projectDirPath) {
      super(projectDirPath);
      this.projectFilePath = Path.join(this.projectDirPath, 'Attenuator.xcodeproj');
   }

   actions() {
      return ['ci', 'build', 'clean', 'test', 'release', 'verify', 'deploy', 'archive'];
   }

   build() {
      let b = new XcodeBuilder(this.projectFilePath);
      b.build('AUHost-macOS');
      b.build('Attenuator-macOS');
   }

   clean() {
      FileSystem.rmdirIfExists('/tmp/Attenuator.dst');
      FileSystem.rmdirIfExists(`${this.projectDirPath}/DerivedData`);
      FileSystem.rmdirIfExists(`${this.projectDirPath}/Build`);
   }

   ci() {
      let b = new XcodeBuilder(this.projectFilePath);
      b.ci('AUHost-macOS');
      b.ci('Attenuator-macOS');
   }
}
