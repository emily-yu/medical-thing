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


var abdominal = scrape("abdominal-wounds");
var burns = scrape("burns");
var epidermolysis = scrape("epidermolysis-bullosa");
var extravasation = scrape("extravasation-wound-images");
var footUlcer = scrape("foot-ulcers");
var legUlcer = scrape("leg-ulcer-images")
var legUlcer2 = scrape("leg-ulcer-images-2");
var malignant = scrape("malignant-wound-images");
var meningitis = scrape("meningitis");
var ortho = scrape("orthopaedic%20wounds");
var misc = scrape("miscellaneous");
var pressureUlcer = scrape("pressure-ulcer-images-a");
var pressureUlcer2 = scrape("pressure-ulcer-images-b")
var pilonidal = scrape("pilonidal-sinus");
var toeInfect = scrape("toes");


function scrape(same){
    var scraper = new Scraper("http://www.medetec.co.uk/slide%20scans/" + same + "/index.html");
    var array = [];

    scraper.scrape(function(image) { 
        console.log(same);
        console.log(image.address);
        image.save()
    });

}

function printArray(same){
    for(var x=0; x<=same.length; x++){
        console.log(same[x])
    }
}

app.listen(8000)
console.log('running on 8000');

