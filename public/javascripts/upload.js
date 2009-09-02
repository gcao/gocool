function addUploadField() {
  var x = Math.floor(Math.random()*10000);
  var fieldId = 'upload_upload' + x;
  var fieldName = 'upload[upload_' + x + ']';
  jQuery('#file_fields').append('<div id="' + fieldId + '"><input name=' + fieldName + ' size="60" type="file" /><input type="button" value="Delete This" onclick="removeUploadField(\'' + fieldId + '\')"/></div>');
  jQuery('#' + fieldId).change(addUploadField);
}

function removeUploadField(id) {
  jQuery('#' + id).fadeOut(function(){jQuery(this).remove();})
}

jQuery(document).ready(function(){
  jQuery('#upload_upload').change(addUploadField);
});