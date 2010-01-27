function addEmailClickHandler() {
  jQuery('.email_edit').click(function(){
    jQuery('#email_container').html('<input id="upload_email" maxlength="60" name="upload[email]" size="60" type="text" />');
    jQuery('#upload_email').focus();
  });
}

function addUploadField() {
  var x = Math.floor(Math.random()*10000);
  var fieldId = 'upload_upload' + x;
  var fieldName = 'upload[upload_' + x + ']';
  jQuery('#file_fields').append('<div id="' + fieldId + '" class="additionalUpload"><input name=' + fieldName + ' size="60" type="file" /><input type="button" value="Delete This" onclick="removeUploadField(\'' + fieldId + '\')"/></div>');
  jQuery('#' + fieldId).change(addUploadField);
}

function removeUploadField(id) {
  jQuery('#' + id).fadeOut(function(){jQuery(this).remove();})
}

function initUploadPage() {
  addEmailClickHandler();
  jQuery('#upload_upload').change(addUploadField);
  jQuery('#resetButton').click(function(){
    document.uploadForm.reset();
    jQuery('.additionalUpload').remove();
  });
}
