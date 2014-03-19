/*! kibana - v3.0.0 - 2014-03-18
 * Copyright (c) 2014 Rashid Khan; Licensed Apache License */

define(["module"],function(a){var b=a.config&&a.config()||{};return{load:function(a,c,d){var e=c.toUrl(a);c(["text!"+a],function(a){b.registerTemplate&&b.registerTemplate(e,a),d(a)})}}});