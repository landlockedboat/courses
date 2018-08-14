$(document).ready(function(){
  add_hover (init_board(16,16));
  $("#resize").click(function(){
    var newWidth = prompt("How many horizontal tiles do you want?");
    var newHeight = prompt("And vertical ones?");
    $("#board").empty();
    add_hover (init_board(newWidth,newHeight))
    alert("Done.");
  });
});

function init_board(width, height, tileSize){
  var $board = $("#board")
  for (i = 0; i<height; i++){
    var $tr = $("<tr></tr>");
    $board.append($tr);
    for (j = 0; j<width; j++){
      $tr.append($("<td class='tile'></td>"));
    }
  }
  var $tile = $(".tile");
  $tile.width(640/width);
  $tile.height(640/height);
  return $tile;
}

function add_hover(tiles){
  tiles.mouseenter(function(){
    var $me = $(this);
    var hasClass = $me.hasClass("randomized");
    if(!hasClass){
      var randCol = 'rgb('
                + (Math.floor(Math.random() * 256)) + ','
                + (Math.floor(Math.random() * 256)) + ','
                + (Math.floor(Math.random() * 256)) + ')';
      $me.css("background-color", randCol);
      $me.addClass("randomized");
    }
    else{
        var opacity = $me.css("opacity");
        if(opacity > 0)
          $me.css("opacity", opacity -.1);
    }
  });
}
