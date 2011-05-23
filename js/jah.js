$(document).ready(function (){
  bg_color = "#dedede";
  paper = Raphael("paper");
  bg = paper.rect(0,0,paper.width,paper.height).attr('fill',bg_color);
  title = paper.text(paper.width/2,100,TITLE).attr({
    "font-size": 30,
    fill: "red"
  });
  set_bg = function(color){
    bg_color = color;
    refresh_bg();
  };
  
  refresh_bg = function(){
    bg.attr('fill',bg_color);
  };

})
