<!doctype html>

<html lang="en">

    <head>
        <title>Site Status</title>

        <meta charset="utf-8">
        <meta name="viewport" content=
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <meta http-equiv="refresh" content="30" />

    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-beta.2/css/bootstrap.min.css" integrity="sha384-PsH8R72JQ3SOdhVi3uxftmaW6Vc51MKb0q5P2rRUpPvrszuE4W1povHYgTpBfshb" crossorigin="anonymous">
   
    <?php
        #web up?
        $xml1 = new SimpleXMLElement(file_get_contents('data_store/web_test.xml'));
        $web_status = $xml1->I32;
        if($web_status == 200){
                    $web_color = "Green";
        }
        elseif($web_status != 200){
                        $web_color = "Red";
        }
        #latency
        $xml2 = new SimpleXMLElement(file_get_contents('baselines/baseline_latency.xml'));
        $latency_base = $xml2->Db;
        $xml3 = new SimpleXMLElement(file_get_contents('data_store/latency_test.xml'));
        $latency_current = $xml3->Db;
        if($latency_current = $latency_base){

                $latency_color = "Green";
        }
        else{$latency_color = "Yellow";}
        #ttl
        $xml4 = new SimpleXMLElement(file_get_contents('baselines/baseline_ttl.xml'));
        $ttl_base = $xml4->U32;
        $xml5 = new SimpleXMLElement(file_get_contents('data_store/ttl_test.xml'));
        $ttl_current = $xml5->U32;
        if($ttl_current = $ttl_base){

                $ttl_color = "Green";
        }
        else{$ttl_color = "Red";}
        #hops
        $xml6 = new SimpleXMLElement(file_get_contents('baselines/baseline_hops.xml'));
        $hops_base = $xml6->I32;
        $xml7 = new SimpleXMLElement(file_get_contents('data_store/hops_test.xml'));
        $hops_current = $xml7->I32;
        if($hops_current = $hops_base){

                $hops_color = "Green";
        }
        else{$hops_color = "Red";}
        #route hash
        $xml8 = new SimpleXMLElement(file_get_contents('data_store/route_consistent.xml'));
        $route = $xml8->I32;
        if($route == 1){
            $route_color = "Green";
        }
        else{$route_color = "Yellow";}
        #dns hash
        $xml9 = new SimpleXMLElement(file_get_contents('data_store/dns_consistent.xml'));
        $dns = $xml9->I32;
        if($dns == 1){
            $dns_color = "Green";
        }
        else{$dns_color = "Red";}

     ?>
    </head>    

    <body style="background-color: #212121;">
        <h1 style="color:white"> Site Test Status </h1>

        <div class="container">
            <div class="row">
                <div class="col-md-9"><h1 style="color:white;">website status</h1></div>
                <div class="col-md-3" style="background-color:<?php echo $web_color; ?>"></div>
            </div>
            <div class="row"></div>
            <div class="row">
                <div class="col-md-3"></div>
                <div class="col-md-3"></div>
                <div class="col-md-3"><h1 style="color: white">Baseline</h1></div>
                <div class="col-md-3"><h1 style="color: white">Current</h1></div>
            </div>
            <div class="row"></div>
            <div class="row">
                <div class="col-md-3" style="background-color:<?php echo $latency_color; ?>"></div>
                <div class="col-md-3"><h1 style="color: white">Ping Latency</h1></div>
                <div class="col-md-3"><h1 style="color: white"><?php echo $latency_base; ?></h1></div>
                <div class="col-md-3"><h1 style="color: white"><?php echo $latency_current; ?></h1></div>
            </div>
            <div class="row"></div>
            <div class="row">
                <div class="col-md-3" style="background-color:<?php echo $ttl_color; ?>"></div>
                <div class="col-md-3"><h1 style="color: white">Time To Live</h1></div>
                <div class="col-md-3"><h1 style="color: white"><?php echo $ttl_base; ?></h1></div>
                <div class="col-md-3"><h1 style="color: white"><?php echo $ttl_current; ?></h1></div>
            </div>
            <div class="row"></div>
            <div class="row">
                <div class="col-md-3" style="background-color:<?php echo $hops_color; ?>"></div>
                <div class="col-md-3"><h1 style="color: white">Network Hops</h1></div>
                <div class="col-md-3"><h1 style="color: white"><?php echo $hops_base; ?></h1></div>
                <div class="col-md-3"><h1 style="color: white"><?php echo $hops_current; ?></h1></div>
            </div>
            <div class="row"></div>
            <div class="row">
                <div class="col-md-3" style="background-color:<?php echo $route_color; ?>"></div>
                <div class="col-md-9"><h1 style="color: white">Route Consistency</h1></div>
            </div>
            <div class="row"></div>
            <div class="row">
                <div class="col-md-3" style="background-color:<?php echo $dns_color; ?>"></div>
                <div class="col-md-9"><h1 style="color: white">DNS Entry Consistency</h1></div>
            </div>

        </div>    
    </body>

</html>