document.observe("dom:loaded",function(){
    var drives = $$(".drive");
    var relevant = drives.select(function(d){return !!d.readAttribute("data-machine")});
    relevant.each(function(drive){
        title=drive.childElements().first();
	      title.observe("mouseover",function(){clients(drive).each(function(ob){ob.addClassName("highlight")})});
      	title.observe("mouseout",function(){clients(drive).each(function(ob){ob.removeClassName("highlight")})});
    });
    $$(".iso, .drive").each(function(el){
      new Draggable(el.identify(),{revert:true});
    });
    $$(".machine").each(function(m){
      Droppables.add(m.identify(),{
        hoverclass:"hover",
        onDrop: function(draggable, droppable){
          if(draggable.hasClassName("iso")){
            var f = droppable.select(".dvd_form")[0];
            f.name.value=draggable.innerHTML;
            f.submit();
          }
          else if(draggable.hasClassName("drive")){
            var f = droppable.select(".drive_form")[0];
            f.uuid.value=draggable.readAttribute("data-uuid");
            f.submit();
          }
        }});
    });

});

function clients(drive){
  if(ss=drive.readAttribute("data-snapshot"))return [$(ss)];
  return [$(drive.readAttribute("data-machine"))];
}


