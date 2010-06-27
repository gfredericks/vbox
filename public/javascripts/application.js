// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults


document.observe("dom:loaded",function(){
    var drives = $$(".drive");
    var relevant = drives.select(function(d){return !!d.readAttribute("data-machine")});
    relevant.each(function(drive){
	object = (function(){
	    if(ss=drive.readAttribute("data-snapshot"))return $(ss);
	    return $(drive.readAttribute("data-machine"));
	})();
	drive.observe("mouseover",function(){object.addClassName("highlight")});
	drive.observe("mouseout",function(){object.removeClassName("highlight")});
    });
});