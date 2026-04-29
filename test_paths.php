<?php
require __DIR__.'/../Chamado/backend/vendor/autoload.php';
$app = require_once __DIR__.'/../Chamado/backend/bootstrap/app.php';
var_dump($app->resourcePath());
var_dump(resource_path('views'));
var_dump(config('view.paths'));
