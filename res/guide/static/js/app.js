webpackJsonp([1],{"1B6L":function(t,e){},"2fyd":function(t,e){},"3YXj":function(t,e,n){"use strict";Object.defineProperty(e,"__esModule",{value:!0});var i={name:"",props:[],data:function(){return{agreementUrl:window.CUSTOM_CONF.userAgreement,title:window.CUSTOM_CONF.name,loadingText:!0,loading:n("cvR0")}},methods:{close:function(){this.$WpsApi.closeWindow()},iframeOnload:function(){var t=this;setTimeout(function(){t.loadingText=!1},2e3)}},mounted:function(){this.$WpsApi.setDragArea(0,0,900,32)},computed:{},components:{}},o={render:function(){var t=this,e=t.$createElement,n=t._self._c||e;return n("div",{staticClass:"Agreement"},[n("div",{staticClass:"bar"},[n("p",{staticClass:"title"},[n("span",[t._v(t._s(t.title))])]),t._v(" "),n("div",{staticClass:"close",on:{click:function(e){t.close()}}},[n("span",{staticClass:"icon icon-x"})])]),t._v(" "),n("div",{staticClass:"content"},[n("div",{directives:[{name:"show",rawName:"v-show",value:t.loadingText,expression:"loadingText"}],staticClass:"loading"},[n("img",{attrs:{src:t.loading}})]),t._v(" "),n("iframe",{staticClass:"extend-box",attrs:{src:t.agreementUrl},on:{load:function(e){t.iframeOnload()}}})])])},staticRenderFns:[]};var a=n("VU/8")(i,o,!1,function(t){n("OGkd")},"data-v-c8b4b8b8",null);e.default=a.exports},"6O+y":function(t,e,n){"use strict";(function(t){var i,o={},a=o.Base64;if(void 0!==t&&t.exports)try{i=n("EuP9").Buffer}catch(t){}var c="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/",r=function(t){for(var e={},n=0,i=t.length;n<i;n++)e[t.charAt(n)]=n;return e}(c),s=String.fromCharCode,l=function(t){var e;return t.length<2?(e=t.charCodeAt(0))<128?t:e<2048?s(192|e>>>6)+s(128|63&e):s(224|e>>>12&15)+s(128|e>>>6&63)+s(128|63&e):(e=65536+1024*(t.charCodeAt(0)-55296)+(t.charCodeAt(1)-56320),s(240|e>>>18&7)+s(128|e>>>12&63)+s(128|e>>>6&63)+s(128|63&e))},u=/[\uD800-\uDBFF][\uDC00-\uDFFFF]|[^\x00-\x7F]/g,f=function(t){return t.replace(u,l)},d=function(t){var e=[0,2,1][t.length%3],n=t.charCodeAt(0)<<16|(t.length>1?t.charCodeAt(1):0)<<8|(t.length>2?t.charCodeAt(2):0);return[c.charAt(n>>>18),c.charAt(n>>>12&63),e>=2?"=":c.charAt(n>>>6&63),e>=1?"=":c.charAt(63&n)].join("")},h=o.btoa?function(t){return o.btoa(t)}:function(t){return t.replace(/[\s\S]{1,3}/g,d)},p=i?function(t){return(t.constructor===i.constructor?t:new i(t)).toString("base64")}:function(t){return h(f(t))},v=function(t,e){return e?p(String(t)).replace(/[+/]/g,function(t){return"+"==t?"-":"_"}).replace(/=/g,""):p(String(t))},m=new RegExp(["[\xc0-\xdf][\x80-\xbf]","[\xe0-\xef][\x80-\xbf]{2}","[\xf0-\xf7][\x80-\xbf]{3}"].join("|"),"g"),w=function(t){switch(t.length){case 4:var e=((7&t.charCodeAt(0))<<18|(63&t.charCodeAt(1))<<12|(63&t.charCodeAt(2))<<6|63&t.charCodeAt(3))-65536;return s(55296+(e>>>10))+s(56320+(1023&e));case 3:return s((15&t.charCodeAt(0))<<12|(63&t.charCodeAt(1))<<6|63&t.charCodeAt(2));default:return s((31&t.charCodeAt(0))<<6|63&t.charCodeAt(1))}},g=function(t){return t.replace(m,w)},C=function(t){var e=t.length,n=e%4,i=(e>0?r[t.charAt(0)]<<18:0)|(e>1?r[t.charAt(1)]<<12:0)|(e>2?r[t.charAt(2)]<<6:0)|(e>3?r[t.charAt(3)]:0),o=[s(i>>>16),s(i>>>8&255),s(255&i)];return o.length-=[0,0,2,1][n],o.join("")},b=o.atob?function(t){return o.atob(t)}:function(t){return t.replace(/[\s\S]{1,4}/g,C)},_=i?function(t){return(t.constructor===i.constructor?t:new i(t,"base64")).toString()}:function(t){return g(b(t))},A=function(t){return _(String(t).replace(/[-_]/g,function(t){return"-"==t?"+":"/"}).replace(/[^A-Za-z0-9+/]/g,""))};o.Base64={VERSION:"2.1.9",atob:b,btoa:h,fromBase64:A,toBase64:v,utob:f,encode:v,encodeURI:function(t){return v(t,!0)},btou:g,decode:A,decodeURI:decodeURI,encodeURIComponent:encodeURIComponent,decodeURIComponent:decodeURIComponent,noConflict:function(){var t=o.Base64;return o.Base64=a,t}},e.a=o.Base64}).call(e,n("f1Eh")(t))},"8/c5":function(t,e,n){"use strict";Object.defineProperty(e,"__esModule",{value:!0});var i=n("Dd8w"),o=n.n(i),a=n("NYxO"),c=n("//Fk"),r=n.n(c),s=n("mvHQ"),l=n.n(s);if(!window.Function.prototype.bind){var u=void 0,f=void 0,d=void 0,h=void 0;window.Function.prototype.bind=function(t){if("function"!=typeof this)throw new TypeError("Function.prototype.bind - what is trying to be bound is not callback");return d=Array.prototype.slice.call(arguments,1),u=this,h=function(){return u.apply(this instanceof f&&t?this:t||window,d.concat(Array.prototype.slice.call(arguments)))},(f=function(){}).prototype=this.prototype,h.prototype=new f,h}}var p=function(t){var e=void 0;try{e=JSON.parse(l()(t))}catch(t){}return e},v=function(t,e){var n;arguments.length>2&&void 0!==arguments[2]&&arguments[2];n=t,t=(Array.isArray?Array.isArray(n):"[object Array]"===Object.prototype.toString.call(n))?t:[],e instanceof Function||(e=function(){});var i=t.length,o=0,a=[],c=0,r=0;function s(t){(t?++c:++r,o<i)&&e({succeed:c,fail:r,count:++o,total:i})}i||e({succeed:c,fail:r,count:o,total:i});for(var l=function(e){setTimeout(function(){var n=new Image;a[e]=n,n.onload=function(){s(!0)},n.onerror=function(){s(!1)},n.src=t[e]},4)},u=0;u<i;u++)l(u)},m={init:1,hover:2,showTableLable:3,leave:4},w={tableFrameId:-1,tableFrameTime:800,tableId:-1,tableTime:14,text2Id:-1,text2Time:1005,waveBigId:-1,waveBigTime:1005},g=p(window.CUSTOM_CONF.effects),C=function(t){return new r.a(function(e,n){v(t,function(t){t.succeed+t.fail===t.total&&e(t)})})},b={name:"MainAnimate",props:[],data:function(){return{isGifLoaded:!1,isHover:!1,isLeave:!0,currentLoadUrls:[],tableFrame:{table:!1,text2:!1,leaveText1:!1},waveBig:!1,UrlsEle:{one:!1,two:!1},hoverState:m.init,effectsUrls:{},frameSwitch:{start:!1,hover:!1,showTable:!1,leave:!1}}},methods:{hoverEnter:function(){var t=this;this.frameSwitch.hover&&this.isLeave&&(this.isLeave=!1,this.clearAll(function(){t.$nextTick(function(){t.hoverState=m.hover,t.showTableFrame()})}))},hoverLeave:function(){var t=this;this.frameSwitch.leave&&(this.clearAll(),this.isLeave=!0,this.$nextTick(function(){t.hoverState=m.leave,t.leaveFrame()}))},showFrame:function(t){return this.hoverState===m[t]},showTableFrame:function(){var t=this;this.clearAll(),this.tableFrame.table=!1,this.tableFrame.text2=!1,w.tableFrameId=setTimeout(function(){t.hoverState=m.showTableLable},w.tableFrameTime),w.tableId=setTimeout(function(){t.tableFrame.table=!0},w.tableTime),w.text2Id=setTimeout(function(){t.tableFrame.text2=!0,t.$nextTick(function(){t.$refs.animate_text2.innerHTML='<img src="'+g.text2+"?_t="+1*new Date+'" class="text">'})},w.text2Time)},leaveFrame:function(){var t=this;this.clearAll(),this.waveBig=!0,w.waveBigId=setTimeout(function(){t.waveBig=!1,t.$nextTick(function(){t.hoverState=m.init})},w.waveBigTime)},clearAll:function(t){clearTimeout(w.tableFrameId),clearTimeout(w.tableId),clearTimeout(w.text2Id),clearTimeout(w.waveBigId),this.$nextTick(function(){t instanceof Function&&t()})}},watch:{},mounted:function(){var t=this;this.currentLoadUrls=[];var e=[],n=[],i={waveRep:0,text1:0,waveSmall:1,table:2,centerMin:2,text2:2,waveBig:3};for(var o in g)if(g.hasOwnProperty(o)&&(e.push(g[o]),i.hasOwnProperty(o))){var a=i[o];n[a]||(n[a]=[]),n[a].push(g[o])}C(n[0]).then(function(e){t.effectsUrls.waveRep=g.waveRep,t.effectsUrls.text1=g.text1,t.isGifLoaded=!0}).then(function(){C(n[1]).then(function(){t.effectsUrls.waveSmall=g.waveSmall,t.frameSwitch.hover=!0}),C(n[2]).then(function(){t.effectsUrls.table=g.table,t.effectsUrls.centerMin=g.centerMin,t.effectsUrls.text2=g.text2,t.frameSwitch.showTable=!0}),C(n[3]).then(function(){t.effectsUrls.waveBig=g.waveBig,t.frameSwitch.leave=!0})})},computed:{},components:{}},_={render:function(){var t=this,e=t.$createElement,i=t._self._c||e;return i("div",{staticClass:"MainAnimate",on:{mouseenter:function(e){if(e.target!==e.currentTarget)return null;t.hoverEnter()},mouseleave:function(e){if(e.target!==e.currentTarget)return null;t.hoverLeave()}}},[t.isGifLoaded?i("div",{staticClass:"animate"},[t.showFrame("init")?i("div",{staticClass:"frame animate-1"},[i("img",{attrs:{src:t.effectsUrls.waveRep}}),t._v(" "),i("img",{staticClass:"text",attrs:{src:t.effectsUrls.text1}})]):t._e(),t._v(" "),t.showFrame("hover")?i("div",{staticClass:"frame animate-1"},[i("img",{attrs:{src:t.effectsUrls.waveSmall}}),t._v(" "),i("img",{staticClass:"text text-1-fade-up",attrs:{src:t.effectsUrls.text1}})]):t._e(),t._v(" "),t.showFrame("showTableLable")?i("div",{staticClass:"frame animate-1"},[t.tableFrame.table?i("img",{staticClass:"gif-table",attrs:{src:t.effectsUrls.table}}):t._e(),t._v(" "),i("img",{staticClass:"label-2",attrs:{src:t.effectsUrls.centerMin}}),t._v(" "),t.tableFrame.text2?i("div",{ref:"animate_text2",staticClass:"text"}):t._e()]):t._e(),t._v(" "),t.showFrame("leave")&&t.waveBig?i("div",{staticClass:"frame animate-3"},[i("img",{attrs:{src:t.effectsUrls.waveBig}})]):t._e()]):i("div",{staticClass:"static"},[i("img",{attrs:{src:n("evIo"),height:"300",width:"300"}}),t._v(" "),i("img",{attrs:{src:n("N5L6"),height:"32",width:"300"}})])])},staticRenderFns:[]};var A=n("VU/8")(b,_,!1,function(t){n("lWK4")},"data-v-1494a9e7",null).exports,x=n("Mn/2"),T={EVENT:{hidePop:"hideConfirmPop"}},y={name:"",data:function(){return{isChecked:!0}},methods:{toggleChecked:function(){this.isChecked=!this.isChecked},confirmOk:function(){this.$WpsApi.startMain(this.isChecked),this.$InfoCollect.sendDocer({event:"home_confirm_use"})},openUserContract:function(){var t=/\?.+$/g.test(this.$route.fullPath),e=this.$route.fullPath.replace(/\/index.*?$/g,"/agreement")+(t?"&":"?")+"pagefrom=index",n=window.location.href.replace(/#.*$/g,"#"+e);this.$WpsApi.openNewWindow(n,null,900,630,!0,!0),this.$InfoCollect.sendDocer({event:"home_trial"})},back:function(){x.a.$emit(T.EVENT.hidePop,this.isChecked)}},computed:o()({},Object(a.c)(["clientType"]),{checkboxIconStyle:function(){return this.isChecked?"icon-checkbox-checked-"+this.clientType:"icon-checkbox-none"}}),components:{}},k={render:function(){var t=this,e=t.$createElement,n=t._self._c||e;return n("div",{staticClass:"Confirm"},[n("div",{staticClass:"mark",on:{click:function(e){t.back()}}}),t._v(" "),n("div",{staticClass:"btn-box"},[n("p",{staticClass:"check-box"},[n("i",{staticClass:"icon",class:t.checkboxIconStyle,on:{click:function(e){t.toggleChecked()}}}),t._v(" "),n("span",[t._v("\u786e\u8ba4\u6dfb\u52a0\u5230\u83dc\u5355\u680f\uff0c\u65b9\u4fbf\u4e0b\u6b21\u4f7f\u7528")])]),t._v(" "),n("p",{staticClass:"common-btn-primise confirm-btn",on:{click:function(e){t.confirmOk()}}},[t._v("\u786e\u8ba4\u5e76\u4f7f\u7528")]),t._v(" "),n("p",{staticClass:"doc",on:{click:function(e){t.openUserContract()}}},[n("span",[t._v("\u6211\u5df2\u7ecf\u9605\u8bfb\u5e76\u540c\u610f\u300a\u6587\u6863\u52a9\u624b\u670d\u52a1\u534f\u8bae\u300b")])])])])},staticRenderFns:[]};var S=n("VU/8")(y,k,!1,function(t){n("1B6L")},"data-v-0b799090",null).exports,U={name:"index",data:function(){return{currentComponent:"",customConf:p(window.CUSTOM_CONF),infoCollectType:{animation:1,default:0}}},computed:o()({},Object(a.c)(["hasLogin"])),methods:{showConfirm:function(){var t=this;this.$InfoCollect.sendDocer({event:"home_trial"}),this.hasLogin?this.currentComponent=S:this.$WpsApi.login().then(function(){t.$WpsApi.checkUserLogin()})},openVideoUrl:function(t){this.$WpsApi.showBrowser(this.customConf.vedioUrl),this.$InfoCollect.sendDocer({event:t===this.infoCollectType.animation?"home_hover_click":"home_video_click"})},notShowAgain:function(){this.$WpsApi.turnDown(),this.$InfoCollect.sendDocer({event:"home_no_need"})}},created:function(){var t=this;x.a.$on(T.EVENT.hidePop,function(e){t.currentComponent=""})},components:{MainAnimate:A,Confirm:S}},F={render:function(){var t=this,e=t.$createElement,n=t._self._c||e;return n("div",{staticClass:"Index"},[n("div",{staticClass:"index-scroll"},[n("div",{staticClass:"index-center-box"},[n("div",{on:{click:function(e){t.openVideoUrl(t.infoCollectType.animation)}}},[n("MainAnimate")],1),t._v(" "),n("div",{staticClass:"name"},[n("p",{staticClass:"title"},[n("span",{staticClass:"txt"},[t._v(t._s(t.customConf.name)),n("i",{staticClass:"icon icon-beta beta"})])]),t._v(" "),n("div",{staticClass:"video-url",on:{click:function(e){t.openVideoUrl()}}},[n("p",{staticClass:"content"},[n("span",{staticClass:"line"},[n("i",{staticClass:"icon icon-vedio"}),t._v(" "),n("i",{staticClass:"time"},[t._v(t._s(t.customConf.vedioTimeLength))]),t._v(" "),n("i",{staticClass:"txt"},[t._v(t._s(t.customConf.vedioText))])])])])]),t._v(" "),n("div",{staticClass:"try-btn-box"},[n("div",{staticClass:"try-btn"},[n("p",{staticClass:"common-btn-primise btn",on:{click:function(e){t.showConfirm()}}},[t._v(t._s(t.customConf.tryBtn.text))]),t._v(" "),n("p",[n("span",{staticClass:"sub",on:{click:function(e){t.notShowAgain()}}},[t._v(t._s(t.customConf.tryBtn.sub))])])])]),t._v(" "),t.currentComponent?n("div",{staticClass:"component-page"},[n(t.currentComponent,{tag:"component"})],1):t._e()])])])},staticRenderFns:[]};var O=n("VU/8")(U,F,!1,function(t){n("2fyd")},"data-v-2e538a1e",null);e.default=O.exports},"Mn/2":function(t,e,n){"use strict";var i=new(n("7+uW").a);e.a=i},N5L6:function(t,e,n){t.exports=n.p+"static/img/text1-cover.png"},NHnr:function(t,e,n){"use strict";Object.defineProperty(e,"__esModule",{value:!0});var i=n("7+uW"),o=n("Dd8w"),a=n.n(o),c=n("NYxO"),r={name:"App",data:function(){return{clientType:"wps"}},methods:a()({},Object(c.b)(["setClientType"])),created:function(){var t=this;this.$WpsApi.checkUserLogin(),this.$WpsApi.getAppType().then(function(e){var n=e.app_type||"wps";t.setClientType(n),t.clientType="Global_"+n||"Global_wps",t.$InfoCollect.sendDocer({event:"home_show"})})}},s={render:function(){var t=this.$createElement,e=this._self._c||t;return e("div",{class:this.clientType,attrs:{id:"app"}},[e("router-view")],1)},staticRenderFns:[]};var l=n("VU/8")(r,s,!1,function(t){n("j8/A")},null,null).exports,u=n("/ocq");i.a.use(u.a);var f=new u.a({routes:[{path:"/",redirect:"/index"},{path:"/index",name:"index",components:n("8/c5")},{path:"/agreement",name:"agreement",components:n("3YXj")}]}),d=n("bOdI"),h=n.n(d),p={state:{clientType:"wps"},getters:{clientType:function(t){return t.clientType}},mutations:h()({},"CLIENT_TYPE",function(t,e){t.clientType=e||"wps"}),actions:{setClientType:function(t,e){(0,t.commit)("CLIENT_TYPE",e)}}},v=n("Mn/2");v.a.$on("userStateChanged",function(t){var e=t.res,n=t.vm,i=e&&e.logined;n.$store.dispatch("setHasLogin",i)});var m={state:{hasLogin:!1,wpsSid:""},getters:{hasLogin:function(t){return t.hasLogin}},mutations:h()({},"HAS_LOGIN",function(t,e){t.hasLogin=!!e}),actions:{setHasLogin:function(t,e){(0,t.commit)("HAS_LOGIN",e)}}};i.a.use(c.a);var w=new c.a.Store({modules:{base:p,user:m}}),g=n("mvHQ"),C=n.n(g),b=n("//Fk"),_=n.n(b),A=n("6O+y"),x={httpPost:!0,httpGet:!0},T=1,y=window.external&&window.external.jsAsynCall||function(){},k=window.cefQuery,S=function(t,e,n,i){return new _.a(function(o,a){var c=t+"_async_callback_"+ ++T,r={method:t,params:"[object Object]"===Object.prototype.toString.call(e)?e:{},callback:c},s=c,l=x.hasOwnProperty(t);if(l){var u=t+"_async_params_callback_"+ ++T;r.params.callback=u,window[c]=function(){delete window[c]},s=u}window[s]=function(t){delete window[s];var e=JSON.parse(A.a.decode(t));if(i instanceof Function&&i(e),"ok"===e.callstatus||l)o(n instanceof Function?n(e.result):e.result);else{var c={result:e.errormsg};a(c)}};var f=A.a.encode(C()(r));k?k({request:'jsAsynCall("'+f+'")',persistent:!1}):y(f)})},U=S,F=function(t){return new _.a(function(e,n){U(t).then(function(t){var n={};try{n=JSON.parse(t)}catch(e){n=t}e(n)}).catch(function(t){n(t)})})},O={setWindowCallBack:function(t,e){window[t]=function(t){t?(t=JSON.parse(A.a.decode(t)),e(t)):e(t)}},login:function(t){return U("login",{loginSrc:t=t||""})},checkUserLogin:function(){U("checkUserLogin")},userStateChanged:function(t){this.setWindowCallBack("userStateChanged",function(e){t instanceof Function&&t(e)})},showBrowser:function(t,e){U((e=e||!1)?"qingOpenVipAutoLoginUrl":"navigateOnNewWindow",{url:t})},openNewWindow:function(t,e,n,i,o,a){U("navigateOnNewWidget",{url:t,transferData:e=e||{},width:n,height:i,bModal:o,closeBtn:a=a||!1})},closeWindow:function(t){t&&this.setWebViewProperty("windowResult",t),U("closeWindow")},httpGet:function(t,e){return U("httpGet",{callback:t.callback,url:t.url,timeout:t.timeout,cookie:t.cookie,header:e})},httpPost:function(t,e){return U("httpPost",{callback:t.callback,url:t.url,timeout:t.timeout,cookie:t.cookie,data:t.data,bRawData:t.bRawData,header:e})},getAppType:function(){return F("getAppType")},getAppInfo:function(){return F("getAppInfo")}},I=S,$=a()({},O,{turnDown:function(){I("turnDown")},startMain:function(t){return I("startMain",{isAddToMenu:!!t})},setDragArea:function(t,e,n,i){I("setDragArea",{left:t,top:e,width:n,height:i})},infoCollect:function(t){"[object Object]"!==Object.prototype.toString.call(t)&&(t={}),I("infoCollect",{args:C()(t)}).then(function(t){})}}),L={install:function(t){t.prototype.$WpsApi=$}},B={sendBJCentre:function(){},sendDocer:function(t){var e=a()({},t);e.type="assistant",$.infoCollect(e)}},N={install:function(t){t.prototype.$InfoCollect=B}};n("nc3M");i.a.config.productionTip=!1,i.a.use(L),i.a.use(N);var E=new i.a({el:"#app",router:f,store:w,components:{App:l},template:"<App/>"});E.$WpsApi.userStateChanged(function(t){v.a.$emit("userStateChanged",{res:t,vm:E})})},OGkd:function(t,e){},cvR0:function(t,e,n){t.exports=n.p+"static/img/wps-loading-96.gif"},evIo:function(t,e,n){t.exports=n.p+"static/img/wave-rep-cover.png"},"j8/A":function(t,e){},lWK4:function(t,e){},nc3M:function(t,e){var n;n={INPUT:!0,TEXTAREA:!0},document.oncontextmenu=function(t){(t||event).returnValue=!1},document.onselectstart=function(t){var e=t||event,i=e.srcElement;return!(!e||!n[i.tagName])},document.ondragstart=function(t){var e=t||event,i=e.srcElement;return!(!e||!n[i.tagName])},document.onkeydown=function(t){if(9===t.keyCode||8===t.keyCode){var e=document.activeElement.tagName;if("INPUT"!==e&&"TEXTAREA"!==e)return!1}},window.alert=function(){},window.confirm=function(){},window.prompt=function(){}}},["NHnr"]);