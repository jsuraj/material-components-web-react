const karmaConfig = require('./scripts/karma/config');

// enable ChromeHeadless Browser
process.env.CHROME_BIN = require('puppeteer').executablePath();

module.exports = function(config) {
  karmaConfig.browsers = ['ChromeHeadless'];
  // karmaConfig.browsers = ['ChromeHeadlessNoSandbox'];
  // karmaConfig.customLaunchers = {
  //   ChromeHeadlessNoSandbox: {
  //     base: 'ChromeHeadless',
  //     flags: ['--no-sandbox', '--disable-setuid-sandbox']
  //   }
  // };
  config.set(karmaConfig);
};
