const karmaConfig = require('./scripts/karma/config');

// enable ChromeHeadless Browser
process.env.CHROME_BIN = require('puppeteer').executablePath();

module.exports = function(config) {
  // karmaConfig.browsers = ['ChromeHeadless'];
  karmaConfig.browsers = ['ChromeHeadlessNoSandbox'];
  karmaConfig.customLaunchers = {
    ChromeHeadlessNoSandbox: {
      base: 'ChromeHeadless',
      flags: ['--headless', '--disable-gpu', '--remote-debugging-port=9222', 'http://0.0.0.0:9876/']
    }
  };
  config.set(karmaConfig);
};
