<!DOCTYPE html>        
<html lang="en">                 
    <head>                       
        <meta charset="utf-8">
        <title>BFGMiner</title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta name="description" content="">
        <meta name="author" content="Jon Poland">

%if status not in ('Idle', 'Not running'):
    <meta http-equiv="refresh" content="15">
%end
        <link href="static/css/bootstrap.min.css" rel="stylesheet">
        <style>
            body {
                padding-top: 60px; /* 60px to make the container go all the way to the bottom of the topbar */
            }
        </style>

        <!--[if lt IE 9]>
            <script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>
        <![endif]-->
    </head>
    <body>
        <div class="navbar navbar-fixed-top">
            <div class="navbar-inner">
                <div class="container">
                    <a class="brand">BFGMiner</a>
                    <ul class="nav">
                        <li><a href="https://bitbucket.org/polandj/synominer/wiki/Home/">Website</a></li>
                        <li><a href="https://bitbucket.org/polandj/synominer/issues/new">Bug</a></li>
                        <li><a href="{{request.script_name}}about">About</a></li>
                    </ul>
                </div>
            </div>
        </div>
        <div class="container-fluid">
            <div class="page-header">
                <h1><img src="static/img/bfgminer.png"> BFGMiner <small>Crypto coin miner</small></h1> 
            </div>
        </div>
        <div class="container-fluid">
            <div class="row-fluid">
               <div class="well span3">
                   <ul class="nav nav-list">
                        <li class="{{request.path == '/' and 'active' or ''}}"><a href="{{request.script_name}}">Control</a></li>
                        <li class="{{request.path == '/log' and 'active' or ''}}"><a href="{{request.script_name}}log">Log</a></li>
                        <li class="divider">
                        <li class="nav-header">
                            {{status}}
%if status not in ('Idle', 'Not running'):
                            <img src="static/img/loading.gif" style="width: 25px; height: 25px; padding-left: 15px;"/>
%end
                        </li>
                   </ul>
                </div> 
%include
        </div>
        </div>
        <script src="static/js/jquery.min.js"></script>
        <script src="static/js/bootstrap.min.js"></script>
    </body>                                                                                                                  
</html>
