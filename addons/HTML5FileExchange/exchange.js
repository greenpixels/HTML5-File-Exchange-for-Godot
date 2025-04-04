var _HTML5FileExchange = {};
_HTML5FileExchange.upload = function(gd_callback) {
    var input = document.createElement('INPUT'); 
    input.setAttribute("type", "file");
    input.click();
    input.addEventListener('change', event => {
        if (event.target.files.length > 0) {
            var file = event.target.files[0];
            var reader = new FileReader();
            this.fileType = file.type;
            this.fileName = file.name;
            reader.readAsArrayBuffer(file);
            reader.onloadend = (evt) => {
                if (evt.target.readyState == FileReader.DONE) {
                    this.result = evt.target.result;
                    gd_callback();
                }
            }
        }
    });
}
