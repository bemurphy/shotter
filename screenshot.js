var casper = require('casper').create({
    viewportSize: {
        width: 1024,
        height: 768
    }
});

var url = casper.cli.get(0);
var filename = casper.cli.get(1);

if (!url || !filename) {
    casper.echo("Usage $ casperjs screenshot.js url filename");
    casper.exit();
}

casper.start(url, function() {
    this.waitUntilVisible('html', function() {
        this.captureSelector(filename, 'html');
        this.echo("Saved screenshot of " + this.getCurrentUrl() + " to " + filename);
    }, function() {
        this.die('Timeout reached.').exit();
    }, 12000);
});

casper.run();
