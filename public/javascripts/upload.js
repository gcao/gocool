function addUploadField() {
  var fieldId = 'upload_upload' + Math.floor(Math.random()*1000);
  jQuery('#file_fields').append('<input id="' + fieldId + '" name="upload[upload]" size="30" type="file" />');
  jQuery('#' + fieldId).change(addUploadField);
}

jQuery(document).ready(function(){
  jQuery('#upload_upload').change(addUploadField);
});