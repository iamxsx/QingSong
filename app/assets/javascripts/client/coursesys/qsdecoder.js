/*
 * = require tween
 * = require resize.min
 * = require_self


 */

function qsdecoder(){

    //增加/兼容requestAnimationFrame
    (function() {
        var lastTime = 0;
        var vendors = ['webkit', 'moz'];
        for(var x = 0; x < vendors.length && !window.requestAnimationFrame; ++x) {
            window.requestAnimationFrame = window[vendors[x] + 'RequestAnimationFrame'];
            window.cancelAnimationFrame = window[vendors[x] + 'CancelAnimationFrame'] ||
                window[vendors[x] + 'CancelRequestAnimationFrame'];
        }

        if (!window.requestAnimationFrame) {
            window.requestAnimationFrame = function(callback, element) {
                var currTime = new Date().getTime();
                var timeToCall = Math.max(0, 16.7 - (currTime - lastTime));
                var id = window.setTimeout(function() {
                    callback(currTime + timeToCall);
                }, timeToCall);
                lastTime = currTime + timeToCall;
                return id;
            };
        }
        if (!window.cancelAnimationFrame) {
            window.cancelAnimationFrame = function(id) {
                clearTimeout(id);
            };
        }

        animate();

        function animate() {
            requestAnimationFrame(animate);
            TWEEN.update();
        }
    }());

    //系统自用变量! 与后端衔接的设置都在这里(写死)
    var _backend = {
        //课程系统文件夹路径
        courseSys: "http://localhost:3000/course-sys",

        //路由处理脚本路径
        router: "/sys/load-course",

        //请求保存页面的路径
        saveapi: "/sys/save-page",

        //保存完之后跳转的链接
        saveRedirect: "http://localhost:3000/users/emp-course",

        //用来适配产品环境的 '/preview' 和 '/ultimate' 两个版本的路径设置
        publishfolder: "/preview"
    };

    var qsd = {

        //用来容纳qsc的容器id
        qscontainer: "qsc_course_container",

        //qsc的英文标识符
        qscname : "",

        //课程所属公司名
        qsccompanyflag : "",

        //开发模式
        debug: false,

        //课程文件
        coursejson: {},

        //课程编号/排序/第几节课
        coursesort: 1,

        //本页面的类型: course | exam   教程 还是 考核
        type: "",

        //初始化
        init: function(config){

            $.each(config,function(k,v){
                qsd._default[k] = config[k];
            });

            this.debug = this._default['debug'];
            this.qscname = this._default["qscname"];
            this.qsccompanyflag = this._default["qsccompanyflag"];
            this.coursejson = this._default["coursejson"];
            this.coursesort = this._default["coursesort"];
            this.browser.bindScrollPerfect();
            this.course.init();

            if(this.debug){
                $("#qsc_course_toolbar").css("display","none");
                this.goToUrl(this._default["indexfile"]);
            }else{
                this.gotoPreparePage();
            }

        },

        //默认变量值
        _default:{
            indexfile: "index.html",
            qscname: "",
            qsccompanyflag: "",
            debug: false,
            coursejson: {},
            coursesort: 1,
            type: "course",
        },

        //加载准备页面
        gotoPreparePage: function(){
            $(".qsc_browser").css("width","200px");
            $(".qsc_browser").css("margin-top","100px");
            $(".qsc_browser_toolbar").css("height","50px");
            $(".qsc_browser_border").css("min-height","140px");
            $(".qsc_browser_border").css("overflow","hidden");
            $(".qsc_browser_title").html("");
            $("#qsc_course_toolbar").css("display","none");

            var animationEnd = 'webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend';
            $(".qsc_browser").addClass('animated bounce').one(animationEnd, function() {
                $(this).removeClass('animated bounce');

                $(this).unbind(animationEnd);

                $(".qsc_browser_border").animate({"min-height":"310px"},150);
                $(".qsc_browser").animate({"width":"600px","margin-top":"57px"},200,function(){
                    $("#"+qsd.qscontainer).html("<h1 class='animated zoomIn qsc_temp_coursename'> 第 "+qsd.coursesort+" 节&nbsp;&nbsp;"+qsd.course.getCourseName()+"</h1>"+
                        "<p class='animated zoomIn qsc_temp_coursedescription'>"+qsd.course.getCourseDescription()+"</p>" +
                        "<div class='animated fadeIn qsc_temp_tips'>我们将模拟您的工作系统并显示在这个窗口中,请根据提示完成操作</div>" +
                        "<div class='animated fadeIn qsc_temp_startbtn' id='qsc_getandgo'>知道了,开始课程</div>"
                    );

                    //正式加载页面,动效
                    $("#qsc_getandgo").click(function(){
                        $("#"+qsd.qscontainer).html("");
                        $(".qsc_browser_title").html(" 第 "+qsd.coursesort+" 节&nbsp;&nbsp;"+qsd.course.getCourseName());

                        var origin = { width : $(".qsc_browser").width()/$(window).width()*100 };
                        var target = { width : 100  };
                        var fullWidthTween = new TWEEN.Tween(origin).to(target, 480).onUpdate(function(){
                            $(".qsc_browser").css("width",origin.width+"%");
                        }).easing(TWEEN.Easing.Exponential.InOut);
                        fullWidthTween.start();

                        qsd.course.mask.showFullMask();
                        $(".qsc_browser_toolbar").animate({"height":"70px"},460);
                        $(".qsc_browser_border").animate({"min-height":"768px"},700,function(){
                            $(".qsc_browser_border").css("overflow-x","scroll");

                            if(qsd.debug){
                                qsd.goToUrl(qsd._default["indexfile"]);
                            }else{
                                if(qsd.coursejson['page'] == undefined){
                                    qsd.goToUrl(qsd._default["indexfile"]);
                                }else{
                                    qsd.goToUrl(qsd.coursejson['page']);
                                }
                            }


                            $("#qsc_course_toolbar").css("display","block");
                            $("#qsc_course_toolbar").css("width","0%");
                            qsd.course.toolbar.hideAll();
                            //加载toolbar动效
                            var origin = { width : 0 };
                            var target = { width : 80  };
                            var ToolbarShowTween = new TWEEN.Tween(origin).to(target, 500).onUpdate(function(){
                                $("#qsc_course_toolbar").css("width",origin.width+"%");
                            }).easing(TWEEN.Easing.Quintic.InOut).delay(800).start()
                                .onComplete(function(){
                                    qsd.course.goNextAction();
                                });


                        });

                    });
                });
            });
        },

        //跳转页面
        goToPage: function(filename){
            browser.sendRequest(filename,"page",function(page){
                $("#"+qsd.qscontainer).html(qsd._preprocessPage(page));
                qsd.bindDataHref();
                browser.history.prehistory.push(filename);
                browser.setUrl(filename);
                browser.bindScrollPerfect();
                browser.getPerfectScrollPosition();
            });
        },

        //跳转到长url
        goToUrl: function(url){
            var thewholeurl = url;
            if(url == browser.getUrl()){
                return;
            }
            if(url.length != browser.getUrl()){
                if(url.indexOf(browser.getUrl())==0){
                    url = url.replace(browser.getUrl(),"");
                }
            }


            var _renderPage = function(compiledUrl,i){
                if(i==compiledUrl.length){
                    return;
                }
                if(compiledUrl[i].split("&")!= "" && compiledUrl[i].split("&").length == 1){
                    browser.sendRequest(compiledUrl[i],"page",function(page){
                        $("#"+qsd.qscontainer).html(qsd._preprocessPage(page));
                        qsd.bindDataHref();
                        i++;
                        _renderPage(compiledUrl,i);
                    });
                }else{
                    var elemid = compiledUrl[i].split("&")[0];
                    var part = compiledUrl[i].split("&")[1];
                    browser.sendRequest(part,"part",function(page){
                        $("#"+elemid).html(qsd._preprocessPage(page));
                        qsd.bindDataHref();
                        i++;
                        _renderPage(compiledUrl,i);
                    });
                }
            }


            var compiledUrl = url.split("#");

            _renderPage(compiledUrl,0);
            browser.history.prehistory.push(browser.getUrl());
            browser.setUrl(thewholeurl);
            browser.bindScrollPerfect();
            browser.getPerfectScrollPosition();

        },

        //获取分页内容 (传入jquery选择器字符串)
        getPart: function(filename,jqSelectorStr){
            browser.sendRequest(filename,"part",function(page){
                $(jqSelectorStr).html(qsd._preprocessPage(page));
                qsd.bindDataHref();
            });
        },


        //绑定data-href
        bindDataHref: function(){
            $("#"+this.qscontainer).find("[data-href]").not("link").not("script").on("click",function(){
                qsd.goToUrl($(this).attr("data-href"));
            });
        },

        //绑定的事件将记录在这里
        eventSet: [],

        //绑定各种事件,element:jq元素,event:事件名称,fn:事件内容
        bind: function(element,event,fn){

            for(var set in this.eventSet){
                if(set["element"] == element){
                    if(set[event] == undefined){
                        set[event] = new Array();
                    }
                    set[event].push(fn);
                    return;
                }
            }

            var temp = {};
            temp.element = element;
            temp[event] = new Array();
            temp[event].push(fn);
            this.eventSet.push(temp);

            element.on(event,fn);

        },

        //取消绑定各种事件,element:jq元素,event:事件名称,fn:事件内容
        unbind: function(element,event){

            for(var set in this.eventSet){
                if(set["element"] == element){
                    if(set[event] != undefined){
                        set[event] = undefined;
                    }
                    return;
                }
            }


            element.off(event);

        },

        //预处理页面
        _preprocessPage: function(page){
            var result = page;

            //处理link标签
            result = page.replace(/(<link[\s]href\s*=\s*"\s*)([\w\/\[\]]+\.css".*>)/g,"$1"+_backend.courseSys+"/"+qsd.qsccompanyflag+_backend.publishfolder+"/"+qsd.qscname+"/assets/css/$2");

            //处理img标签
            result = result.replace(/(<img[\s]src\s*=\s*["|']\s*)(.+\.[a-zA-Z0-9]{2,6}["|'].*\/?>)/g,"$1"+_backend.courseSys+"/"+qsd.qsccompanyflag+_backend.publishfolder+"/"+qsd.qscname+"/assets/img/$2");
            return result;
        },


        //关于课程文件的所有操作绑定在这里
        course: {

            //指针,指向当前的step
            _steppointer: -1,

            //指针,指向当前的action
            _actionpointer: -1,

            //step总数
            _steplength: 0,

            //初始化部分信息
            init: function(){
                this._steplength = qsd.coursejson["steps"].length;
                this.toolbar.clearIndicators();
                this.mask.init();

                for(var i=0;i<this._steplength;i++){
                    this.toolbar.addIndicator(i);
                }

                $(".qsc_correct_icon").css("display","none");
            },

            //获取课程名称
            getCourseName : function(){
                return qsd.coursejson["coursename"];
            },

            //获取课程描述
            getCourseDescription: function(){
                return qsd.coursejson["coursedescription"];
            },

            //获取step文字,num计数从0开始
            getStep: function(num){
                return qsd.coursejson["steps"][num]["title"];
            },

            //获取action文字,两个num计数都从0开始
            getAction: function(stepnum,actionnum){
                return qsd.coursejson["steps"][stepnum]["actions"][actionnum]["title"];
            },

            //获取action描述文字,两个num计数都从0开始
            getActionDesc: function(stepnum,actionnum){
                return qsd.coursejson["steps"][stepnum]["actions"][actionnum]["description"];
            },

            //获取当前step文字
            getNowStep: function(){
                return this.getStep(this._steppointer);
            },

            //获取当前action文字
            getNowAction: function(){
                return this.getAction(this._steppointer,this._actionpointer);
            },
            //获取当前action文字描述
            getNowActionDesc: function(){
                return this.getActionDesc(this._steppointer,this._actionpointer);
            },

            //获取action需要操作的对象id [data-qscid]
            getActionQscId: function(stepnum,actionnum){
                return qsd.coursejson["steps"][stepnum]["actions"][actionnum]["qscid"];
            },
            //获取当前action需要操作的对象id [data-qscid]
            getNowctionQscId: function(){
                return this.getActionQscId(this._steppointer,this._actionpointer);
            },

            //获取action的操作事件,只有通过了此事件才能算作是完成了这一步的教学
            getActionEvent: function(stepnum,actionnum){
                return qsd.coursejson["steps"][stepnum]["actions"][actionnum]["event"];
            },
            //获取当前action的操作事件,只有通过了此事件才能算作是完成了这一步的教学
            getNowActionEvent: function(){
                return this.getActionEvent(this._steppointer,this._actionpointer);
            },

            //获取action的期望值,用于判断步骤是否通过的关键
            getActionExpectedValue: function(stepnum,actionnum){
                return qsd.coursejson["steps"][stepnum]["actions"][actionnum]["expectedvalue"];
            },
            //获取当前action的期望值,用于判断步骤是否通过的关键
            getNowActionExpectedValue: function(){
                return this.getActionExpectedValue(this._steppointer,this._actionpointer);
            },
            //获取action的toolbar按钮文字内容
            getActionGetBtnText: function(stepnum,actionnum){
                return qsd.coursejson["steps"][stepnum]["actions"][actionnum]["getbtntext"];
            },
            //获取当前action的toolbar按钮文字内容
            getNowActionGetBtnText: function(){
                return this.getActionGetBtnText(this._steppointer,this._actionpointer);
            },
            //获取action是否要阻止默认事件进行
            getPreventDefault: function(stepnum,actionnum){
                if(qsd.coursejson["steps"][stepnum]["actions"][actionnum]["preventdefault"] == undefined){
                    return false;
                }else{
                    return qsd.coursejson["steps"][stepnum]["actions"][actionnum]["preventdefault"];
                }
            },
            //获取当前action是否要阻止默认事件进行
            getNowPreventDefault: function(){
                return this.getPreventDefault(this._steppointer,this._actionpointer);
            },

            //监听教程事件以判断通过与否
            listenEvent: function(){
                var event = qsd.course.getNowActionEvent();

                //用来标记当前事件是不是已经完成了,避免不必要的冲突
                var operatedDone = false;
                switch(event){

                    //根据value(值)来确认通过本步骤
                    case "checkvalue":
                        var selector = "[data-qscid='"+qsd.course.getNowctionQscId()+"']";
                        $(selector).focus();
                        var valuechecker = setInterval(function(){
                            if($(selector).val()==qsd.course.getNowActionExpectedValue()){

                                //锁定操作
                                $("#qsc_mask_top").focus();
                                qsd.course.mask.showFullRealMask();

                                clearInterval(valuechecker);
                                qsd.course.toolbar.finishActionAnimate(function(){
                                    if(qsd.course.getNowPreventDefault()){
                                        qsd.course.cancelPreventDefault();
                                    }
                                    qsd.course.goNextAction();
                                });
                            }
                        },10);
                        break;

                    //通过点击toolbar的按钮来通过本步骤
                    case "get":
                        $("#qsc_action_react").append("<div class='qsc_toolbar_assistbtn' id='qsc_t_assistbtn'>"+qsd.course.getNowActionGetBtnText()+"</div>");
                        var originShape = { opacity: "0" , fontsize: "0" , paddingud: "0" , paddinglr:"0"};
                        var targetShape = {opacity : "1" , fontsize: "16" , paddingud: "8" , paddinglr: "16"};
                        var ShowAssistBtnTween = new TWEEN.Tween(originShape).to(targetShape, 400).onUpdate(function(){
                            $("#qsc_t_assistbtn").css("opacity",originShape.opacity);
                            $("#qsc_t_assistbtn").css("font-size",originShape.fontsize);
                            $("#qsc_t_assistbtn").css("padding-top",originShape.paddingud);
                            $("#qsc_t_assistbtn").css("padding-bottom",originShape.paddingud);
                            $("#qsc_t_assistbtn").css("padding-left",originShape.paddinglr);
                            $("#qsc_t_assistbtn").css("padding-right",originShape.paddinglr);
                        }).easing(TWEEN.Easing.Back.Out).delay(200).start().onComplete(function(){
                            $("#qsc_t_assistbtn").on("click",function(){
                                $("#qsc_t_assistbtn").animate({"opacity":"0"});
                                $("#qsc_t_assistbtn").off("click");
                                if(qsd.course.getNowPreventDefault()){
                                    qsd.course.cancelPreventDefault();
                                }
                                qsd.course.goNextAction();
                            });
                        });

                        break;

                    //通过点击来完成步骤
                    case "click":
                        var selector = "[data-qscid='"+qsd.course.getNowctionQscId()+"']";
                        $(selector).click(function(){
                            //锁定操作
                            $("#qsc_mask_top").focus();
                            qsd.course.mask.showFullRealMask();

                            qsd.course.toolbar.finishActionAnimate(function(){
                                if(qsd.course.getNowPreventDefault()){
                                    qsd.course.cancelPreventDefault();
                                }
                                qsd.course.goNextAction();
                            });
                        });
                        break;

                    //通过按键来完成步骤
                    case "keydown":
                        var selector = "[data-qscid='"+qsd.course.getNowctionQscId()+"']";
                        $(selector).focus();
                        $(selector).keydown(function(e){
                            if(e.which == qsd.course.getNowActionExpectedValue()){

                                //锁定操作
                                $("#qsc_mask_top").focus();
                                qsd.course.mask.showFullRealMask();

                                qsd.course.toolbar.finishActionAnimate(function(){
                                    if(qsd.course.getNowPreventDefault()){
                                        qsd.course.cancelPreventDefault();
                                    }
                                    qsd.course.goNextAction();
                                });
                            }

                        });
                        break;
                }
            },


            //进行下一步的教程
            goNextAction: function(){
                var actionType = "action";
                if(this._steppointer == -1){
                    this._steppointer++;
                    actionType = "first";
                }
                this._actionpointer++;

                //自动加载下一个step
                if(this._actionpointer>=qsd.coursejson["steps"][this._steppointer]["actions"].length){
                    actionType = "step";
                    this._steppointer++;
                    if(this._steppointer>=this._steplength){
                        //找不到下一步骤了
                        this.toolbar.showFinishToolBar();
                        this.mask.showFullMask();
                        return;
                    }
                    this._actionpointer = 0;
                }

                //阻止默认事件
                if(this.getNowPreventDefault()){
                    this.preventDefault();
                    this._invoveEvent();
                }else{
                    this.preventDefault();
                    this._invoveEvent();
                    this.cancelPreventDefault();
                }

                //同步到界面上
                $("#qsc_mask_top").focus();
                this.mask.setRealHoleToFull();


                this.toolbar.setStepNum(this._steppointer+1);
                var isActionDescChanged = false;
                if($("#qsc_action_desc").html()==this.getNowActionDesc()){
                    isActionDescChanged = true;
                }
                this.toolbar.setActionDescText(this.getNowActionDesc());
                if(actionType == "first"){
                    this.toolbar.setActionText(this.getNowAction());
                    this.toolbar.setStepText(this.getNowStep());
                    this.toolbar.showAnimate(this.listenEvent);
                    this.scrollPageToElement(function(){
                        console.log("asd");
                        qsd.course.mask.scrollToElement(qsd.coursejson["steps"][qsd.course._steppointer]["actions"][qsd.course._actionpointer]["blinkid"]);
                    });

                }else if(actionType == "action"){
                    this.toolbar.nextActionAnimate(isActionDescChanged,this.listenEvent);
                    this.scrollPageToElement(function(){
                        qsd.course.mask.scrollToElement(qsd.coursejson["steps"][qsd.course._steppointer]["actions"][qsd.course._actionpointer]["blinkid"]);
                    });

                }else if(actionType == "step"){
                    this.toolbar.nextStepAnimate(this.listenEvent);
                    this.scrollPageToElement(function(){
                        qsd.course.mask.scrollToElement(qsd.coursejson["steps"][qsd.course._steppointer]["actions"][qsd.course._actionpointer]["blinkid"]);
                    });

                }




            },


            //滑动页面到需要交互的元素身上
            scrollPageToElement : function(cb){
                var selector = "[data-qscid='"+this.getNowctionQscId()+"']";
                var tempele = $(selector);
                var tempele2 = $(selector);
                while(tempele[0] != $("body")[0]){
                    if(tempele.parent().css("overflow") == "scroll"
                        || tempele.parent().css("overflow-x") == "scroll"
                        || tempele.parent().css("overflow-y") == "scroll"
                    ){
                        tempele.parent().animate({
//                            scrollTop: (tempele2.position().top+tempele.parent().scrollTop() - $(window).height()/4)+"px",
                            scrollLeft: (tempele2.position().left+tempele.parent().scrollLeft() - $(window).width()/4)+"px"
                        },250,function(){
                            cb();
                        });
//
//                        console.log("scrolltop:"+(tempele2.position().top+tempele.parent().scrollTop() - $(window).height()/4)+"px");
//                        console.log("scrollleft:"+(tempele2.position().left+tempele.parent().scrollLeft() - $(window).width()/4)+"px");
//
//                        console.log("tempele");
//                        console.log(tempele);
//                        console.log("tempele2");
//                        console.log(tempele2);
//                        console.log("-------------");
//                        tempele2 = tempele2.parent();
                    }
                    tempele = tempele.parent();
                }
            },


            //使用这个方法来阻止元素本身的事件
            preventDefault: function(){
                var selector = "[data-qscid='"+this.getNowctionQscId()+"']";
                $(selector).unbind();
            },

            //使用这个方法来取消掉已经阻止元素本身的事件
            cancelPreventDefault: function(){
                var selector = "[data-qscid='"+this.getNowctionQscId()+"']";
                for(var val in qsd.eventSet){
                    if(qsd.eventSet[val]["element"][0] == $(selector)[0]){
                        for(var key in qsd.eventSet[val]){
                            if(key=="element"){continue;}
                            for(var fn in qsd.eventSet[val][key]){
                                $(selector).on(key,qsd.eventSet[val][key][fn]);
                            }
                        }
                    }
                }
            },

            //干预事件,青松系统将干预部分按键或事件以达到课程效果
            _invoveEvent:function(){
                var selector = "[data-qscid='"+this.getNowctionQscId()+"']";
                //干预过程
                $(selector).keydown(function(e){

                    //阻止tab键
                    if(e.which == 9){
                        e.preventDefault();
                        return false;
                    }
                });

            },

            //关于工具栏的所有界面设置
            toolbar: {

                //设置step文字
                setStepText: function(text){
                    $("#qsc_step").html(text);
                },

                //设置step数字
                setStepNum: function(num){
                    $("#qsc_stepnum").html(num);
                },

                //设置action文字
                setActionText: function(text){
                    $("#qsc_action_content").html(text);
                },

                //设置action描述
                setActionDescText: function(text){
                    $("#qsc_action_desc").html(text);
                },

                //添加指示点,利用id进行定位
                addIndicator: function(id){
                    $(".qsc_t_indicator_container").append("<div class='qsc_t_indicator' data-id='"+id+"'></div>");
                },
                //添加指示点,利用id进行定位
                clearIndicators: function(){
                    $(".qsc_t_indicator_container").html("");
                },

                //隐藏所有元素
                hideAll: function(){
                    $("#qsc_step").css("display","none");
                    $("#qsc_stepnum").css("visibility","hidden");
                    $("#qsc_action").css("display","none");
                    $("#qsc_action_desc").css("display","none");
                },

                //开场动画
                showAnimate: function(cb){
                    var animationEnd = 'webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend';
                    $("#qsc_step").css("display","inline-block");
                    $("#qsc_step").addClass("animated fadeInLeft").one(animationEnd,function(){
                        $("#qsc_step").removeClass("animated fadeInLeft");
                        $("#qsc_step").unbind(animationEnd);


                        $("#qsc_action").css("display","inline-block");
                        $("#qsc_action_desc").css("display","inline-block");
                        $("#qsc_stepnum").css("visibility","visible");
                        $("#qsc_stepnum").addClass("animated rubberBand");
                        $("#qsc_action").addClass("animated fadeIn");
                        $("#qsc_action_desc").addClass("animated fadeIn").one(animationEnd,function(){
                            $("#qsc_action_desc").removeClass("animated fadeIn");
                            $("#qsc_stepnum").removeClass("animated rubberBand");
                            $("#qsc_step").unbind(animationEnd);
                            qsd.course.toolbar.animateFinishFlag.showAnimate = true;
                            cb();
                        });
                    });


                },

                //记录动画是否已经播放完毕
                animateFinishFlag: {
                    actionAnimate:false,
                    stepAnimate: false,
                    showAnimate: false,
                },

                //进行下一个action的动画,isActionDescChanged:action描述文字是否有变化
                nextActionAnimate: function(isActionDescChanged,cb){
                    var animationEnd = 'webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend';
                    $("#qsc_action").addClass("animated fadeOutUp");
                    $("#qsc_action").one(animationEnd,function(){
                        $("#qsc_action").removeClass("animated fadeOutUp");
                        $("#qsc_action").unbind(animationEnd);

                        qsd.course.toolbar.setActionText(qsd.course.getNowAction());
                        $("#qsc_action").addClass("animated fadeInUp");
                        $("#qsc_action").one(animationEnd,function(){
                            $("#qsc_action").removeClass("animated fadeInUp");
                            $("#qsc_action").unbind(animationEnd);
                            qsd.course.toolbar.animateFinishFlag.actionAnimate = true;
                            cb();
                        });
                    });
                },
                //进行下一个step的动画
                nextStepAnimate: function(cb){
                    var animationEnd = 'webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend';
                    $("#qsc_step").addClass("animated fadeOutRight");
                    $("#qsc_step").one(animationEnd,function(){
                        $("#qsc_step").removeClass("animated fadeOutRight");
                        $("#qsc_step").unbind(animationEnd);

                        $(".qsc_t_indicator[data-id='"+(qsd.course._steppointer-1)+"']").addClass("done");
                        qsd.course.toolbar.setStepText(qsd.course.getNowStep());
                        $("#qsc_step").addClass("animated fadeInLeft");
                        $("#qsc_step").one(animationEnd,function(){
                            $("#qsc_step").removeClass("animated fadeInLeft");
                            $("#qsc_step").unbind(animationEnd);
                        });
                    });

                    setTimeout(function(){
                        $("#qsc_action").addClass("animated fadeOut");
                        $("#qsc_action").one(animationEnd,function(){
                            $("#qsc_action").removeClass("animated fadeOut");
                            $("#qsc_action").unbind(animationEnd);

                            qsd.course.toolbar.setActionText(qsd.course.getNowAction());
                            $("#qsc_action").addClass("animated fadeIn");
                            $("#qsc_action").one(animationEnd,function(){
                                $("#qsc_action").removeClass("animated fadeIn");
                                $("#qsc_action").unbind(animationEnd);

                                $("#qsc_stepnum").addClass("animated rubberBand");
                                $("#qsc_stepnum").one(animationEnd,function(){
                                    $("#qsc_stepnum").removeClass("animated rubberBand");
                                    $("#qsc_stepnum").unbind(animationEnd);
                                    qsd.course.toolbar.animateFinishFlag.stepAnimate = true;
                                    cb();
                                });
                            });
                        });
                    },250);
                },

                //当一个action完成后执行这个动画,cb为回调函数
                finishActionAnimate: function(cb){
                    $(".qsc_correct_icon").css("display","block");
                    $(".qsc_correct_icon").css("opacity","0");
                    var iconposition = { top:0 ,left:0};
                    iconposition.top = parseInt($("#qsc_mask_realright").css("height").split("px")[0])/2+parseInt($("#qsc_mask_realtop").css("height").split("px")[0]);
                    iconposition.left = parseInt($("#qsc_mask_realright").css("left").split("px")[0])-40;
                    $(".qsc_correct_icon").css("top",iconposition.top+"px");
                    $(".qsc_correct_icon").css("left",iconposition.left+"px");

                    //显示正确图标
                    var originShape = { opacity: "0" , width: "0" , height: "0"};
                    var targetShape = {opacity : "1" , width: "20" , height: "20"};
                    var ShowCorrectIconTween = new TWEEN.Tween(originShape).to(targetShape, 400).onUpdate(function(){
                        $(".qsc_correct_icon").css("opacity",originShape.opacity);
                        $(".qsc_correct_icon").css("width",originShape.width+"px");
                        $(".qsc_correct_icon").css("height",originShape.height+"px");
                        $(".qsc_correct_icon").css("top",iconposition.top-originShape.height/2+"px");
                        $(".qsc_correct_icon").css("left",iconposition.left-originShape.width/2+"px");
                    }).easing(TWEEN.Easing.Back.Out).start().onComplete(function(){
                        var originShape = {opacity : "1" , width: "20" , height: "20"};
                        var targetShape = { opacity: "0" , width: "0" , height: "0"};
                        var ShowCorrectIconTween = new TWEEN.Tween(originShape).to(targetShape, 400).onUpdate(function(){
                            $(".qsc_correct_icon").css("opacity",originShape.opacity);
                            $(".qsc_correct_icon").css("width",originShape.width+"px");
                            $(".qsc_correct_icon").css("height",originShape.height+"px");
                            $(".qsc_correct_icon").css("top",iconposition.top-originShape.height/2+"px");
                            $(".qsc_correct_icon").css("left",iconposition.left-originShape.width/2+"px");
                        }).easing(TWEEN.Easing.Back.Out).delay(1000).start().onComplete(function(){
                            cb();
                        });

                    });



                },

                //显示课程结束的toolbar
                showFinishToolBar: function(){

                    $("#qsc_course_toolbar_finish").css("display","block");
                    $("#qsc_course_toolbar_finish").css("opacity","0");

                    var originShape = { opacity: "0"};
                    var targetShape = {opacity : "1"};
                    var ShowFinishToolBarTween = new TWEEN.Tween(originShape).to(targetShape, 700).onUpdate(function(){
                        $("#qsc_course_toolbar_finish").css("opacity",originShape.opacity);
                    }).easing(TWEEN.Easing.Linear.None);

                    var originShape1 = { opacity: "1"};
                    var targetShape1 = {opacity : "0"};
                    var HideToolBarTween = new TWEEN.Tween(originShape1).to(targetShape1, 700).onUpdate(function(){
                        $("#qsc_course_toolbar").css("opacity",originShape1.opacity);
                    }).easing(TWEEN.Easing.Linear.None);

                    ShowFinishToolBarTween.start();
                    HideToolBarTween.start();
                }

            },


            //遮罩
            mask: {

                //初始化mask
                init: function(){
                    $(".qsc_mask").keydown(function(e){
//                        console.log(e.which);
                        if((e.ctrlKey || e.metaKey) && e.which ==82 || e.which == 116){
                            //用于浏览器刷新的按钮 (MAC - meta+R , Windows - F5)
                        }else{
                            e.preventDefault();
                            return false;
                        }

                    });

                    $(".qsc_mask").css("opacity",this.maskOpacity);

                    $("[data-masktype='partmask']").click(function(){
                        qsd.course.mask.blinkAnimate();
                    });
                    this.hideFullMask();
                    this.hideMask();
                    this.initMaskPosition();
                },

                //mask的最暗透明度
                maskOpacity: 0.3,

                //第一次遮罩出现时,遮罩应该在的位置和大小
                initMaskPosition: function(){
                    $("#qsc_mask_top").css("height","50%");
                    $("#qsc_mask_top").css("width","100%");
                    $("#qsc_mask_top").css("top","0px");
                    $("#qsc_mask_top").css("left","0px");
                    $("#qsc_mask_left").css("height","0px");
                    $("#qsc_mask_left").css("width","50%");
                    $("#qsc_mask_left").css("top","50%");
                    $("#qsc_mask_left").css("left","0px");

                    $("#qsc_mask_right").css("height","0px");
                    $("#qsc_mask_right").css("width","50%");
                    $("#qsc_mask_right").css("top","50%");
                    $("#qsc_mask_right").css("left","50%");

                    $("#qsc_mask_bottom").css("height","50%");
                    $("#qsc_mask_bottom").css("width","100%");
                    $("#qsc_mask_bottom").css("top","50%");
                    $("#qsc_mask_bottom").css("left","0px");
                },

                //隐藏遮罩
                hideMask: function(){
                    $("#qsc_mask_top").css("visibility","hidden");
                    $("#qsc_mask_bottom").css("visibility","hidden");
                    $("#qsc_mask_left").css("visibility","hidden");
                    $("#qsc_mask_right").css("visibility","hidden");

                    $("#qsc_mask_realtop").css("visibility","hidden");
                    $("#qsc_mask_realbottom").css("visibility","hidden");
                    $("#qsc_mask_realleft").css("visibility","hidden");
                    $("#qsc_mask_realright").css("visibility","hidden");
                },

                //显示遮罩
                showMask: function(){
                    $("#qsc_mask_top").css("visibility","visible");
                    $("#qsc_mask_bottom").css("visibility","visible");
                    $("#qsc_mask_left").css("visibility","visible");
                    $("#qsc_mask_right").css("visibility","visible");

                    $("#qsc_mask_realtop").css("visibility","visible");
                    $("#qsc_mask_realbottom").css("visibility","visible");
                    $("#qsc_mask_realleft").css("visibility","visible");
                    $("#qsc_mask_realright").css("visibility","visible");
                },

                //显示全屏遮罩
                showFullMask: function(){
                    $("#qsc_mask_full").css("visibility","visible");
                    $("#qsc_mask_full").css("width",this.maskFullWidth);
                    $("#qsc_mask_full").css("height",this.maskFullHeight);
                    $("#qsc_mask_full").focus();
                },

                //隐藏全屏遮罩
                hideFullMask: function(){
                    $("#qsc_mask_full").css("visibility","hidden");
                },

                //显示全屏遮罩
                showFullRealMask: function(){
                    $("#qsc_mask_realfull").css("visibility","visible");
                    $("#qsc_mask_realfull").css("width",this.maskFullWidth);
                    $("#qsc_mask_realfull").css("height",this.maskFullHeight);
                    $("#qsc_mask_realfull").focus();
                },

                //隐藏全屏遮罩
                hideFullRealMask: function(){
                    $("#qsc_mask_realfull").css("visibility","hidden");
                },

                //遮罩的宽高度
                maskFullWidth: "100%",
                maskFullHeight: "100%",

                //遮罩孔洞信息
                maskhole:  { top:0, left:0 ,width :0 , height: 0},

                //刷新遮罩宽高度
                refreshFullSize: function(){
                    this.maskFullHeight = browser.browserInnerLayerHeight;
                    this.maskFullWidth = browser.browserInnerLayerWidth;

                    $("#qsc_mask_full").css("width",this.maskFullWidth+"px");
                    $("#qsc_mask_full").css("height",this.maskFullHeight+"px");
                },

                //从元素获取遮罩孔洞信息
                calHoleFromElement: function(blinkid){
                    var ele = $("[data-blinkid='"+blinkid+"']");
                    if(ele.length == 0){
                        ele = $("[data-qscid='"+blinkid+"']");
                    }

                    //用于存放元素相对于 青松浏览器的位置
                    var position = { top: 0 , left: 0};

                    //用于存放元素的大小
                    var size = { width: 0 , height: 0};

                    //用于存放blink的padding值,默认为5
                    var padding = 5;

                    //获取相对位置
                    var _getPosition = function(){
                        var tempele = ele;
                        while(tempele[0] != $("#qsc_course_container")[0]){
                            position.top += tempele.position().top+parseInt(tempele.css("margin-top").split("px")[0]);
                            position.left += tempele.position().left+parseInt(tempele.css("margin-left").split("px")[0]);
                            tempele = tempele.offsetParent();
                        }
                    }

                    //获取元素大小
                    var _getSize = function(){
                        size.width += ele.outerWidth();
                        size.height += ele.outerHeight();
                    }

                    //获取blinkpadding
                    var _getPadding = function(){
                        if(ele.attr("data-blinkpadding") != undefined){
                            padding = parseInt(ele.attr("data-blinkpadding"));
                        }else{
                            padding = 5;
                        }
                    }

                    //计算孔洞的位置和大小
                    var _calHole = function(){
                        qsd.course.mask.maskhole.top = position.top - padding;
                        qsd.course.mask.maskhole.left = position.left - padding;

                        qsd.course.mask.maskhole.top = qsd.course.mask.maskhole.top > 0 ? qsd.course.mask.maskhole.top : 0;
                        qsd.course.mask.maskhole.left = qsd.course.mask.maskhole.left > 0 ? qsd.course.mask.maskhole.left : 0;

                        if(size.width == 0 || size.height ==0){
                            qsd.course.mask.maskhole.width = 0;
                            qsd.course.mask.maskhole.height = 0;
                        }else{
                            qsd.course.mask.maskhole.width = size.width + padding * 2;
                            qsd.course.mask.maskhole.height = size.height + padding * 2;
                        }
                        if(qsd.course.mask.maskhole.width+qsd.course.mask.maskhole.left> browser.browserInnerLayerWidth){
                            qsd.course.mask.maskhole.width = browser.browserInnerLayerWidth - qsd.course.mask.maskhole.left;
                        }

                        if(qsd.course.mask.maskhole.height+qsd.course.mask.maskhole.top> browser.browserInnerLayerHeight){
                            qsd.course.mask.maskhole.height = browser.browserInnerLayerHeight - qsd.course.mask.maskhole.top;
                        }

                    }
                    _getSize();
                    _getPadding();
                    _getPosition();
                    _calHole();
                },

                //滑动遮罩到某元素
                scrollToElement: function(blinkid){
                    this.calHoleFromElement(blinkid);
                    this.scrollToHole();
                },

                //滑动遮罩到孔洞
                scrollToHole: function(){

                    //四个遮罩的位置尺寸信息
                    var up = { left:0,top:0,width:0,height:0};
                    var down = { left:0,top:0,width:0,height:0};
                    var left = { left:0,top:0,width:0,height:0};
                    var right = { left:0,top:0,width:0,height:0};

                    up.height = this.maskhole.top;
                    up.width = qsd.browser.browserInnerLayerWidth;
                    up.top = 0;
                    up.left = 0;

                    left.height = this.maskhole.height;
                    left.width = this.maskhole.left;
                    left.top = up.height;
                    left.left = 0;

                    right.height = this.maskhole.height;
                    right.width = qsd.browser.browserInnerLayerWidth - left.width - this.maskhole.width;
                    right.width = right.width > 0 ? right.width : 0;
                    right.top = up.height;
                    right.left = left.width + this.maskhole.width;

                    down.height = qsd.browser.browserInnerLayerHeight - up.height - this.maskhole.height;
                    down.height = down.height > 0 ? down.height : 0;
                    down.width = qsd.browser.browserInnerLayerWidth;
                    down.top = up.height + this.maskhole.height;
                    down.left = 0;



                    //透明度变化 - 消失
                    var originColor = { opacity: this.maskOpacity};
                    var targetColor = {opacity : "0" };
                    var OpacityDispearTween = new TWEEN.Tween(originColor).to(targetColor, 300).onUpdate(function(){
                        $("#qsc_mask_top").css("opacity",originColor.opacity);
                        $("#qsc_mask_bottom").css("opacity",originColor.opacity);
                        $("#qsc_mask_left").css("opacity",originColor.opacity);
                        $("#qsc_mask_right").css("opacity",originColor.opacity);
                    }).easing(TWEEN.Easing.Linear.None).delay(2500).onComplete(function(){
                        qsd.course.mask.hideFullRealMask();
                        qsd.course.mask.setRealHole();
                    });

                    //滑动动画
                    this.showMask();
                    var origin = {
                        uptop: $("#qsc_mask_top").css("top").split("px")[0],
                        upleft: $("#qsc_mask_top").css("left").split("px")[0],
                        upwidth: $("#qsc_mask_top").css("width").split("px")[0],
                        upheight: $("#qsc_mask_top").css("height").split("px")[0],

                        bottomtop: $("#qsc_mask_bottom").css("top").split("px")[0],
                        bottomleft: $("#qsc_mask_bottom").css("left").split("px")[0],
                        bottomwidth: $("#qsc_mask_bottom").css("width").split("px")[0],
                        bottomheight: $("#qsc_mask_bottom").css("height").split("px")[0],

                        lefttop: $("#qsc_mask_left").css("top").split("px")[0],
                        leftleft: $("#qsc_mask_left").css("left").split("px")[0],
                        leftwidth: $("#qsc_mask_left").css("width").split("px")[0],
                        leftheight: $("#qsc_mask_left").css("height").split("px")[0],

                        righttop: $("#qsc_mask_right").css("top").split("px")[0],
                        rightleft: $("#qsc_mask_right").css("left").split("px")[0],
                        rightwidth: $("#qsc_mask_right").css("width").split("px")[0],
                        rightheight: $("#qsc_mask_right").css("height").split("px")[0],
                    };
                    var target = {
                        uptop: up.top,
                        upleft: up.left,
                        upwidth: up.width,
                        upheight: up.height,

                        bottomtop: down.top,
                        bottomleft: down.left,
                        bottomwidth: down.width,
                        bottomheight: down.height,

                        lefttop: left.top,
                        leftleft: left.left,
                        leftwidth: left.width,
                        leftheight: left.height,

                        righttop: right.top,
                        rightleft: right.left,
                        rightwidth: right.width,
                        rightheight: right.height,

                    };
                    var ScrollTween = new TWEEN.Tween(origin).to(target, 500).onUpdate(function(){
                        $("#qsc_mask_top").css("height",origin.upheight+"px");
                        $("#qsc_mask_top").css("width",origin.upwidth+"px");
                        $("#qsc_mask_top").css("top",origin.uptop+"px");
                        $("#qsc_mask_top").css("left",origin.upleft+"px");

                        $("#qsc_mask_left").css("height",origin.leftheight+"px");
                        $("#qsc_mask_left").css("width",origin.leftwidth+"px");
                        $("#qsc_mask_left").css("top",origin.lefttop+"px");
                        $("#qsc_mask_left").css("left",origin.leftleft+"px");

                        $("#qsc_mask_right").css("height",origin.rightheight+"px");
                        $("#qsc_mask_right").css("width",origin.rightwidth+"px");
                        $("#qsc_mask_right").css("top",origin.righttop+"px");
                        $("#qsc_mask_right").css("left",origin.rightleft+"px");

                        $("#qsc_mask_bottom").css("height",origin.bottomheight+"px");
                        $("#qsc_mask_bottom").css("width",origin.bottomwidth+"px");
                        $("#qsc_mask_bottom").css("top",origin.bottomtop+"px");
                        $("#qsc_mask_bottom").css("left",origin.bottomleft+"px");
                    }).easing(TWEEN.Easing.Quintic.InOut).onComplete(function(){});

                    //透明度变化 - 出现
                    var originColor1 = { opacity: $("#qsc_mask_top").css("opacity")};
                    var targetColor1 = {opacity : this.maskOpacity };
                    var OpacityAppearTween = new TWEEN.Tween(originColor1).to(targetColor1, 100).onUpdate(function(){
                        $("#qsc_mask_top").css("opacity",originColor1.opacity);
                        $("#qsc_mask_bottom").css("opacity",originColor1.opacity);
                        $("#qsc_mask_left").css("opacity",originColor1.opacity);
                        $("#qsc_mask_right").css("opacity",originColor1.opacity);
                    }).easing(TWEEN.Easing.Linear.None).chain(ScrollTween,OpacityDispearTween).start().onComplete(function(){});

//                    this.setRealHole();
                    this.hideFullMask();

                },

                //设置真实遮罩为全屏遮罩
                setRealHoleToFull: function(){
                    $("#qsc_mask_realtop").css("height",browser.browserInnerLayerHeight+"px");
                    $("#qsc_mask_realtop").css("width",browser.browserInnerLayerWidth+"px");
                    $("#qsc_mask_realtop").css("top","0px");
                    $("#qsc_mask_realtop").css("left","0px");
                },

                //设置真实遮罩,将作用于data-qscid身上,此外的元素无法被点到
                setRealHole: function(){
                    var up = { left:0,top:0,width:0,height:0};
                    var down = { left:0,top:0,width:0,height:0};
                    var left = { left:0,top:0,width:0,height:0};
                    var right = { left:0,top:0,width:0,height:0};

                    var qscele = $("[data-qscid='"+qsd.course.getNowctionQscId()+"']");

                    //如果为event为get的话,设置全屏不能按
                    if(qsd.course.getNowActionEvent() == "get" ){
                        this.showFullRealMask();
                        return;
                    }

                    var position = {top:0,left:0};

                    var _getPosition = function(){
                        var tempele = qscele;
                        while(tempele[0] != $("#qsc_course_container")[0]){
                            position.top += tempele.position().top+parseInt(tempele.css("margin-top").split("px")[0]);
                            position.left += tempele.position().left+parseInt(tempele.css("margin-left").split("px")[0]);
                            tempele = tempele.offsetParent();
                        }
                    }

                    _getPosition();

                    up.height = position.top+parseInt(qscele.css("margin-top").split("px")[0]);
                    up.width = qsd.browser.browserInnerLayerWidth;
                    up.top = 0;
                    up.left = 0;

                    left.height = qscele.outerHeight();
                    left.width = position.left+parseInt(qscele.css("margin-left").split("px")[0]);
                    left.top = up.height;
                    left.left = 0;

                    right.height = qscele.outerHeight();
                    right.width = qsd.browser.browserInnerLayerWidth - left.width - qscele.outerWidth();
                    right.width = right.width > 0 ? right.width : 0;
                    right.top = up.height;
                    right.left = left.width+ qscele.outerWidth();

                    down.height = qsd.browser.browserInnerLayerHeight - up.height - qscele.outerHeight();
                    down.height = down.height > 0 ? down.height : 0;
                    down.width = qsd.browser.browserInnerLayerWidth;
                    down.top = up.height + qscele.outerHeight();
                    down.left = 0;

                    $("#qsc_mask_realtop").css("height",up.height+"px");
                    $("#qsc_mask_realtop").css("width",up.width+"px");
                    $("#qsc_mask_realtop").css("top",up.top+"px");
                    $("#qsc_mask_realtop").css("left",up.left+"px");

                    $("#qsc_mask_realleft").css("height",left.height+"px");
                    $("#qsc_mask_realleft").css("width",left.width+"px");
                    $("#qsc_mask_realleft").css("top",left.top+"px");
                    $("#qsc_mask_realleft").css("left",left.left+"px");

                    $("#qsc_mask_realright").css("height",right.height+"px");
                    $("#qsc_mask_realright").css("width",right.width+"px");
                    $("#qsc_mask_realright").css("top",right.top+"px");
                    $("#qsc_mask_realright").css("left",right.left+"px");

                    $("#qsc_mask_realbottom").css("height",down.height+"px");
                    $("#qsc_mask_realbottom").css("width",down.width+"px");
                    $("#qsc_mask_realbottom").css("top",down.top+"px");
                    $("#qsc_mask_realbottom").css("left",down.left+"px");
                },

                //闪烁动画
                blinkAnimate: function(){

                    //只有在遮罩完全透明的时候才显示
                    if($("#qsc_mask_top").css("opacity")>0.05){
                        return;
                    }

                    var originOpacity = { opacity: "0"};
                    var targetOpacity = { opacity: this.maskOpacity};

                    //透明动画
                    var OpacityAppearTween = new TWEEN.Tween(originOpacity).to(targetOpacity, 250).onUpdate(function(){
                        $("#qsc_mask_top").css("opacity",originOpacity.opacity);
                        $("#qsc_mask_bottom").css("opacity",originOpacity.opacity);
                        $("#qsc_mask_left").css("opacity",originOpacity.opacity);
                        $("#qsc_mask_right").css("opacity",originOpacity.opacity);
                    }).easing(TWEEN.Easing.Quadratic.Out);

                    var originOpacity1 = { opacity: this.maskOpacity};
                    var targetOpacity1 = { opacity: "0"};
                    var OpacityAppearTween1 = new TWEEN.Tween(originOpacity1).to(targetOpacity1, 250).onUpdate(function(){
                        $("#qsc_mask_top").css("opacity",originOpacity1.opacity);
                        $("#qsc_mask_bottom").css("opacity",originOpacity1.opacity);
                        $("#qsc_mask_left").css("opacity",originOpacity1.opacity);
                        $("#qsc_mask_right").css("opacity",originOpacity1.opacity);
                    }).easing(TWEEN.Easing.Quadratic.Out);

                    var originOpacity2 = { opacity: "0"};
                    var targetOpacity2 = { opacity: this.maskOpacity};
                    var OpacityAppearTween2 = new TWEEN.Tween(originOpacity2).to(targetOpacity2, 250).onUpdate(function(){
                        $("#qsc_mask_top").css("opacity",originOpacity2.opacity);
                        $("#qsc_mask_bottom").css("opacity",originOpacity2.opacity);
                        $("#qsc_mask_left").css("opacity",originOpacity2.opacity);
                        $("#qsc_mask_right").css("opacity",originOpacity2.opacity);
                    }).easing(TWEEN.Easing.Quadratic.Out);

                    var originOpacity3 = { opacity: this.maskOpacity};
                    var targetOpacity3 = { opacity: "0"};
                    var OpacityAppearTween3 = new TWEEN.Tween(originOpacity3).to(targetOpacity3, 250).onUpdate(function(){
                        $("#qsc_mask_top").css("opacity",originOpacity3.opacity);
                        $("#qsc_mask_bottom").css("opacity",originOpacity3.opacity);
                        $("#qsc_mask_left").css("opacity",originOpacity3.opacity);
                        $("#qsc_mask_right").css("opacity",originOpacity3.opacity);
                    }).easing(TWEEN.Easing.Quadratic.Out);

                    OpacityAppearTween.chain(OpacityAppearTween1);
                    OpacityAppearTween1.chain(OpacityAppearTween2);
                    OpacityAppearTween2.chain(OpacityAppearTween3);
                    OpacityAppearTween.start();

                }

            }



        }


    };


    //模拟浏览器行为的组件
    var browser = {

        _url: "",

        setUrl: function(url){
            this._url = url;
        },

        getUrl: function(){
            return this._url;
        },

        history: {
            //后退历史
            prehistory: [],

            //前进历史
            nexhistory: []
        },

        //发送请求,只适合用于请求 page 和 part
        sendRequest: function(filename,type,callback){
            $.ajax({
                url: _backend.router,
                data: {
                    type: type,
                    filename: filename,
                    company_id: qsd.qsccompanyflag,
                    course_sys_name: qsd.qscname
                },
                dataType: "html",
                success: function(page){
                    callback(page);
                },
                error: function(){

                }
            });
        },

        //浏览器内图层宽度
        browserInnerLayerWidth: 0,


        //浏览器内图层高度
        browserInnerLayerHeight: 0,


        //刷新浏览器宽内图层高度
        refreshInnerLayerSize: function(){
            this.browserInnerLayerWidth = $("#"+qsd.qscontainer).width();
            this.browserInnerLayerHeight = $("#"+qsd.qscontainer).height();
            qsd.course.mask.refreshFullSize();
        },

        //优化滚动条显示
        bindScrollPerfect: function(){
            $("#"+qsd.qscontainer).bind("resize",function(){
                browser.refreshInnerLayerSize();
                _bindscroll();
            });
            _bindscroll();

            function _bindscroll(){
                $(document).unbind("scroll");
                $(document).scroll(function(){
                    browser.getPerfectScrollPosition();

                });
            }


        },

        //获取最佳的底部滚动条位置
        getPerfectScrollPosition: function(){
            var expectedHeight = $(window).height() + $(document).scrollTop()-32-35-6-19-57-74-(17-_getScrollWidth());
            if(expectedHeight >= $("#"+qsd.qscontainer).height() && $("#"+qsd.qscontainer).height()>0){
                expectedHeight = $("#"+qsd.qscontainer).height();
            }
            $(".qsc_browser_border").css("min-height",expectedHeight+"px");
            $(".qsc_browser_border").css("height",expectedHeight+"px");

            //获取滚动条宽度
            function _getScrollWidth() {
                var noScroll, scroll, oDiv = document.createElement("div");
                oDiv.style.cssText = "position:absolute; top:-1000px; width:100px; height:100px; overflow:hidden;";
                noScroll = document.body.appendChild(oDiv).clientWidth;
                oDiv.style.overflowY = "scroll";
                scroll = oDiv.clientWidth;
                document.body.removeChild(oDiv);
                return noScroll-scroll;
            }
        }
    };

    //对外公开的api
    var api = {

        //获取分页面
        getPart: function(filename,jqSelectorStr){
            qsd.getPart(filename,jqSelectorStr);
        },

        //跳转页面
        goToUrl: function(url){
            qsd.goToUrl(url);
        },

        //绑定事件,element:jq元素,event:事件名称 ,fn:事件内容
        bind: function(element,event,fn){
            qsd.bind(element,event,fn);
        },
        //取消绑定事件,element:jq元素,event:事件名称 ,fn:事件内容
        unbind: function(element,event){
            qsd.unbind(element,event);
        },

        //获取图片url
        getImageUrl: function(filename){
            return _backend.courseSys+"/"+qsd.qsccompanyflag+_backend.publishfolder+"/"+qsd.qscname+"/assets/img/"+filename;
        },

        //给用户存放数据的地方
        data: {}
    };

    qsd.browser = browser;
    qsd.api = api;

    return qsd;

};
