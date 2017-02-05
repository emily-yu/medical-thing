var express = require('express')
var app = express();
var bodyParser = require('body-parser');
var Scraper = require("image-scraper");

app.use(bodyParser.urlencoded({ extended: true })); 
app.use(express.static(__dirname));
// app.set('view engine', 'html');
app.set('views', __dirname+'/views');
// app.engine('html', engines.mustache);


app.get('/', function (req, res) {
    console.log(started);
});

app.post('/projectDetails', function(req, res){
    var user = req.param('thing');
});


scrape("abdominal-wounds");

scrape("burns");

function scrape(same, array){
    var scraper = new Scraper("http://www.medetec.co.uk/slide%20scans/" + same + "/index.html");
    
    console.log("Got here");

    scraper.scrape(function(image) { 
        console.log(image.address);
        array.push(image.address);
    });
}

app.listen(8000)
console.log('running on 8000');

