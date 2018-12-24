
<%@page contentType="text/html" pageEncoding="UTF-8"%>
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
            .draggable { width: 200px; height: 200px; padding: 0.5em; float: left; margin: 0 10px 10px 0; }
            #draggable, #draggable2 { margin-bottom:20px; }
            #draggable { cursor: n-resize; }
            #draggable2 { cursor: e-resize; }
            #place { width: 73%; height:450px; border:2px solid #ccc; padding: 10px; }
            h3 { clear: left; }
            img{width: 100px ;height: 65px; align:center;}
            p{font: bold 10px arial,serif;text-align:center;color:#4C0085;font-size:15px;}
        </style>
        <script>
            var model = null;
            var dlgmodel = null;
            $(document).ready(function () {

                dlgmodel = new Vue({
                    el: "#dlg",
                    data: {
                        stu_name: "",
                        stu_id: "",
                        pc_id: "",
                        pc_places: []
                    }
                });

                $.ajax("places", {
                    success: function (data) {
                        //console.log(data);
                        model = new Vue({
                            el: "#place",
                            data: {
                                pc_places: data,
                            },methods:{
                                Cancel:function (i) {
                                    $.ajax("placeset?pc_id="+i,{
                                        type:"DELETE",
                                        success:function(d){
                                            window.location.reload();
                                        }
                                    });
                                }
                            }
                        });

                    }
                });

                $.ajax("placeset", {
                    success: function (data) {
                        dlgmodel.pc_places = data;
                    }

                });
            });


            function apply() {
                dlgmodel.stu_name = "";
                dlgmodel.stuid = "";
                dlgmodel.pc_id = "";

                $("#dlg").dialog({
                    modal: true,
                    buttons: [
                        {
                            text: "OK",
                            click: function () {
                                console.log(dlgmodel.pc_id);
                                $.ajax("placeset", {
                                    type: "POST",
                                    data: {
                                        stu_name: dlgmodel.stu_name,
                                        stu_id: dlgmodel.stu_id,
                                        pc_id: dlgmodel.pc_id
                                    }, success: function (d) {

                                        window.location.reload();
                                    }
                                });
                                $(this).dialog("close");
                            }
                        }
                    ]
                });
            }


        </script>
    </head>
    <body>
        <div>
            <div align="center" id="place">
                <div class="draggable ui-widget-content" v-for="(pc_place,index) in pc_places">
                    <p class="ui-widget-header">{{pc_place.pc_id}}</p>
                    <img  src='https://openclipart.org/image/2400px/svg_to_png/295842/publicdomainq-0011569wcikfl.png'>
                    <p v-bind:id="pc_place.pc_id" >{{pc_place.stu_name}}</p>
                    <button v-on:click="Cancel(pc_place.pc_id);">Cancel</button>
                </div>
            </div>
        </div> 
        <input type="button" value="APPLY" onclick="apply();"/>

        <div id="dlg" style="display:none">
            NAME<input type="text" v-model="stu_name"/><br/><br/>
            STUID<input type="text"v-model="stu_id"/><br/><br/>

            <label>Select a PC</label>
            <select name="place" id="places" v-model="pc_id">
                <option selected="selected">choose</option>
                <option v-for="(pc_place,index) in pc_places">{{pc_place.pc_id}}</option>
            </select>
        </div>
    </body>
</html>
