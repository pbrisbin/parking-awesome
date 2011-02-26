{-# LANGUAGE QuasiQuotes  #-}
{-# LANGUAGE TypeFamilies #-}
--
-- pbrisbin 2010
--
module Test where

import Yesod
import Network.Wai.Handler.SimpleServer (run)

data Test = Test
type Handler = GHandler Test Test
type Widget  = GWidget  Test Test

mkYesod "Test" [$parseRoutes| 
    /                RootR GET
    /#String/#String BboxR GET
    |]

instance Yesod Test where approot _ = ""

getRootR :: Handler RepHtml
getRootR = defaultLayout $ do
    setTitle $ string "Hackday Civic API"
    addHamlet [$hamlet|
        %h1 Hackday
        %article
            %p
                This is a general purpose App for testing our Hack Day 
                APIs.  If you don't get it, don't worry about it.

            %p
                Also, if you haven't noticed, I'm no longer forwarding 
                8080 to 80 on this server. It's time to let go of that 
                redirect.

            %h3 Usage

            %pre
                http://pbrisbin.com:8080/$$dataset/$$bbox
            %p
                %a!href="/bos_fire_hydrants/-71.062520,42.358028,-71.059516,42.360089"
                    example: "/bos_fire_hydrants/-71.062520,42.358028,-71.059516,42.360089"
        |]

getBboxR :: String -> String -> Handler RepHtml
getBboxR api bbox = defaultLayout $ do
    setTitle $ string $ "Testing " ++ api
    addJulius [$julius|
        function tester(dataset, bbox) {
            var content;
            var feature;

            $.ajax({
                url: "http://civicapi.com/" + dataset,
                dataType: 'jsonp',
                data: {
                    "bbox": bbox
                },
                success: function(o) {
                    // heading
                    content += '<tr>';
                    content += '<th>Type</th>';
                    content += '<th>Geo type</th>';
                    content += '<th>X coordinate</th>';
                    content += '<th>Y coordinate</th>';
                    content += '</tr>';

                    for (i in o.features) {
                        feature = o.features[i];

                        // feature
                        content += '<tr>';
                        content += '<td>' + feature.type                    + '</td>';
                        content += '<td>' + feature.geometry.type           + '</td>';
                        content += '<td>' + feature.geometry.coordinates[0] + '</td>';
                        content += '<td>' + feature.geometry.coordinates[1] + '</td>';
                        content += '</tr>';
                    }

                    $('table.output').html(content);
                }
            });
        }
        |]

    addHamlet [$hamlet|
        %h1 $api$ within $bbox$
        %table.output
        %script!src="//ajax.googleapis.com/ajax/libs/jquery/1.4.4/jquery.min.js"
        %script $$(function() { tester('$api$', '$bbox$'); })
        |]

main :: IO ()
main = putStrLn "Loaded" >> toWaiApp Test >>= run 8080
