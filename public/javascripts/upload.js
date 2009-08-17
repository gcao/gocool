function addUploadField() {
  var fieldId = 'upload_upload' + Math.floor(Math.random()*1000);
  jQuery('#file_fields').append('<div id="' + fieldId + '"><input name="upload[upload]" size="60" type="file" /><input type="button" value="Delete This" onclick="removeUploadField(\'' + fieldId + '\')"/></div>');
  jQuery('#' + fieldId).change(addUploadField);
}

function removeUploadField(id) {
  jQuery('#' + id).fadeOut(function(){jQuery(this).remove();})
}

jQuery(document).ready(function(){
  jQuery('#upload_upload').change(addUploadField);
});