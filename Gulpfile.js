import cp from 'child_process';
import path from 'path';
import fs from 'fs';
import gulp from 'gulp';
import os from 'os';
import url from 'url';
import plist from 'plist';

const rootDirPath = path.dirname(url.fileURLToPath(import.meta.url));

/**
 * @param {string} cmd
 * @param {string?} cwd
 */
function _run(cmd, cwd) {
   console.log('ℹ️  ' + cmd);
   cp.execSync(cmd, { stdio: 'inherit', cwd: cwd ?? rootDirPath });
}

//~~~

export class Version {
   #versionNumberKey = 'APP_PROJECT_VERSION';
   #buildNumberKey = 'APP_BUNDLE_VERSION';
   #filePath;
   #lines;

   constructor(filePath) {
      this.#filePath = filePath;
      this.#lines = fs.readFileSync(filePath).toString().trim().split('\n');
   }

   get version() {
      const line = this.#lines.filter((item) => item.startsWith(this.#versionNumberKey))[0];
      const value = line.split('=')[1].trim();
      return value;
   }

   get build() {
      const line = this.#lines.filter((item) => item.startsWith(this.#buildNumberKey))[0];
      const value = line.split('=')[1].trim();
      return parseInt(value);
   }

   bump() {
      const latestTag = cp.execSync('git describe --tags --abbrev=0').toString().trim();
      const components = latestTag.split('.');
      const last = parseInt(components[components.length - 1]);
      components[components.length - 1] = last + 1;
      const newTag = components.join('.');
      if (newTag === this.version) {
         console.log('Nothing to do. Skipping.');
         return;
      }

      const newBuild = this.build + 1;
      this.#lines = [`${this.#versionNumberKey} = ${newTag}`, `${this.#buildNumberKey} = ${newBuild}`];

      const contents = this.#lines.join('\n') + '\n';
      fs.writeFileSync(this.#filePath, contents);
   }
}

//~~~

const v = new Version(path.join(rootDirPath, 'Configuration/Version.xcconfig'));
const appName = 'AUHost';
const xcArchiveFileName = `${appName}-${v.version}x${v.build}.xcarchive`;
const xcArchiveFilePath = path.join(process.env.MCA_XC_ARCHIVES, xcArchiveFileName);
const zipArchiveFileName = `${appName}_v${v.version}.zip`;
const appFileName = `${appName}.app`;
const appFileNameWithVersion = `${appName}_${v.version}.app`;
const installedAppFilePath = path.join(process.env.MCA_APPS, appFileNameWithVersion);
const notarizationFilePath = path.join(rootDirPath, 'build', zipArchiveFileName);

function makeExportOptions() {
   const exportOptionsJson = {
      destination: 'export',
      method: 'developer-id',
      provisioningProfiles: {
         'com.microcodingapps.oss.AUHost': 'OSS AUHost',
      },
      signingCertificate: 'Developer ID Application',
      signingStyle: 'manual',
      teamID: 'H3M62US4J7',
   };
   const exportOptions = plist.build(exportOptionsJson);
   return exportOptions;
}

function archive() {
   const buildDirPath = fs.mkdtempSync(path.join(os.tmpdir(), `${appName}-archive-`));
   const exportDirPath = path.join(buildDirPath, 'Export');
   const archiveFilePath = path.join(buildDirPath, 'Build', xcArchiveFileName);

   if (fs.existsSync(xcArchiveFilePath)) {
      throw `Archive already exists at path "${xcArchiveFilePath}".`;
   }
   const args = `-arch x86_64 -arch arm64 ONLY_ACTIVE_ARCH=NO DEVELOPMENT_TEAM=H3M62US4J7 PROVISIONING_PROFILE_SPECIFIER="OSS AUHost" CODE_SIGN_IDENTITY="Developer ID Application"`;
   _run(`xcodebuild -project AUHost.xcodeproj -scheme AUHost -archivePath ${archiveFilePath} ${args} archive`);

   const exportOptions = makeExportOptions();
   const exportOptionsFilePath = path.join(buildDirPath, 'ExportOptions.plist');
   fs.writeFileSync(exportOptionsFilePath, exportOptions);
   _run(
      `xcodebuild -exportArchive -archivePath ${archiveFilePath} -exportPath ${exportDirPath} -exportOptionsPlist ${exportOptionsFilePath}`,
   );

   _run(`zip -9 -r ${zipArchiveFileName} ${appFileName}`, exportDirPath);

   const newFilePath = path.join(exportDirPath, appFileNameWithVersion);
   const exportedFilePath = path.join(exportDirPath, appFileName);
   fs.renameSync(exportedFilePath, newFilePath);

   const zipArchiveFilePath = path.join(exportDirPath, zipArchiveFileName);
   _run(`ditto ${zipArchiveFilePath} ${notarizationFilePath}`);
   _run(`ditto ${newFilePath} ${installedAppFilePath}`);
   _run(`ditto ${archiveFilePath} ${xcArchiveFilePath}`);

   fs.rmdirSync(buildDirPath, { recursive: true, force: true });
}

function cleanArchive() {
   const filesToRemove = [xcArchiveFilePath, installedAppFilePath, notarizationFilePath];
   for (const file of filesToRemove) {
      console.log(`Will remove file: ${file}`);
      fs.rmdirSync(file, { recursive: true, force: true });
   }
}

function notarizationSubmit() {
   // See: https://developer.apple.com/documentation/security/notarizing_macos_software_before_distribution/customizing_the_notarization_workflow/notarizing_apps_when_developing_with_xcode_12_and_earlier
   const cmd = `xcrun altool --notarize-app --primary-bundle-id "com.microcodingapps.oss.AUHost" -u ${process.env.MCA_XC_DEV_ID_OSS} -p "@keychain:mca-notarization" --file ${notarizationFilePath}`;
   _run(cmd);
}

function notarizationHistory() {
   const cmd = `xcrun altool --notarization-history 0 -u ${process.env.MCA_XC_DEV_ID_OSS} -p "@keychain:mca-notarization"`;
   _run(cmd);
}

//~~~

gulp.task('note-subm', (cb) => {
   notarizationSubmit();
   cb();
});

gulp.task('note-hist', (cb) => {
   notarizationHistory();
   cb();
});

gulp.task('default', (cb) => {
   console.log('✅ Available tasks:');
   cp.execSync('gulp -T', { stdio: 'inherit' });
   cb();
});

gulp.task('arch-build', (cb) => {
   archive(false);
   cb();
});

gulp.task('arch-clean', (cb) => {
   cleanArchive(false);
   cb();
});

gulp.task('finish', (cb) => {
   const buildNum = v.version;
   console.log(`Creating tag: "${buildNum}"`);
   cp.execSync(`git tag "${buildNum}"`, { stdio: 'inherit' });
   cp.execSync(`git push origin "${buildNum}"`, { stdio: 'inherit' });
   cb();
});
