function dbagile_get_debug(form_id) {
  $.ajax({type: "GET", 
          url: "debug", 
          data: $(form_id).serialize(), 
          dataType: "json",
    error: function(data) {
      alert(data);
    },
    success: function(data) {
	    alert(data);
    }
  });
  return false;
}  
function dbagile_post_debug(form_id) {
  $.ajax({type: "POST", 
          url: "debug", 
          data: $(form_id).serialize(), 
          dataType: "json",
    error: function(data) {
      alert(data);
    },
    success: function(data) {
	    alert(data);
    }
  });
  return false;
}  
function dbagile_get_call(form_id) {
  $.ajax({type: "GET", 
          url: "/sqlite/basic_values", 
          data: $(form_id).serialize(), 
          dataType: "json",
    error: function(data) {
      alert(data);
    },
    success: function(data) {
	    alert(data);
    }
  });
  return false;
}  
function dbagile_post_call(form_id) {
  $.ajax({type: "POST", 
          url: "/sqlite/basic_values", 
          data: $(form_id).serialize(), 
          dataType: "json",
    error: function(data) {
      alert(data);
    },
    success: function(data) {
	    alert(data);
    }
  });
  return false;
}  
