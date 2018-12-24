<!DOCTYPE html>
<html>
    <head>
        <title>Start Page</title>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <script src="https://code.jquery.com/jquery-2.2.4.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/vue"></script>
        <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.min.js"></script>
        <link href="https://code.jquery.com/ui/1.12.1/themes/ui-lightness/jquery-ui.css" rel="stylesheet" type="text/css" />
        <link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
        <style>
            fieldset {
                border: 0;
                margin-left: 0px;
                width: 150px;
                height: 150px;
            }
            label {
                display: blue;
                margin: 20px 0 0 0;
            }


        </style>
        <script>
            var model = null;
            $(document).ready(function () {
                model = new Vue({
                    "el": "#dlg",
                    "data": {
                        "pc_place": {}
                    }
                });
            });
            function query() {
                $.ajax("placeset", {
                    "data": {
                        "cp_id": $("#qid").val()
                    }, "success": function (d) {
                        model.pc_place = d;
                    }
                });
            }

           
           
        </script>
    </head>
    <body>
        <div id="dlg">
            id:<input type="text" v-model="pc_place.pc_id"/><br/>
            password:<input type="text" v-model="pc_place.vacancy"/>
        </div>

        <table id="place" border="1">
            <tr v-for="(pc_place,index) in pc_places">
                <td>{{index}}</td>
                <td>{{pc_place.pc_id}}</td>
                <td>{{pc_place.vacancy}}</td>
            </tr>
        </table>
        <fieldset>
            <label>Select a PC</label>
            <select name="place" id="placen" >
                <option selected="selected">choose</option>
                <option v-for="(pc_place,index) in pc_places">{{pc_place.pc_id}}</option>
            </select>
        </fieldset>
        
        test<input type="text" id='test'/> <br/>
    </body>
</html>
