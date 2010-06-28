document.observe("dom:loaded",function(){
    var drives = $$(".drive");
    var relevant = drives.select(function(d){return !!d.readAttribute("data-machine")});
    relevant.each(function(drive){
        title=drive.childElements().first();
	title.observe("mouseover",function(){clients(drive).each(function(ob){ob.addClassName("highlight")})});
	title.observe("mouseout",function(){clients(drive).each(function(ob){ob.removeClassName("highlight")})});
    });
});

function clients(drive){
  if(ss=drive.readAttribute("data-snapshot"))return [$(ss)];
  return [$(drive.readAttribute("data-machine"))];
}