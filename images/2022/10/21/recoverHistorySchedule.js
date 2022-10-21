// ==UserScript==
// @name         记住阅读进度
// @namespace    http://tampermonkey.net/
// @version      2.6.0
// @description  记住页面阅读进度，即使对于单页面，也能很好的工作！
// @match      *://*/*
// @exclude  http://127.0.0.1*
// @exclude  http://localhost*
// @author       zhuangjie
// @icon         data:image/gif;base64,R0lGODlhAQABAAAAACH5BAEKAAEALAAAAAABAAEAAAICTAEAOw==
// @license MIT
// ==/UserScript==
 
 
 
(function() {
   'use strict';
    // Your code here...
    // 解决广工商学校选课网无法显示左边栏：原因是脚本中加了 window.onload 有关
 
    // 获取滚动历史高度
    let item_content = localStorage.getItem(getCurrentUrl())
    let history_high = item_content == null?0:parseFloat(item_content);
    // 初始化程序
    do {
        if(history_high <= getDocumentHeight() || document.readyState == "complete") {
           init();
           break;
        }
    }while(history_high <= getDocumentHeight() || document.readyState == "complete");
 
 
 
    //有动画地滚动
    let st = null; //保证多次执行 ScrollTo 函数不会相互影响
    function ScrollTo(scroll, top) {
 
        if(st != null ) {
            //关闭上一次未执行完成的滚动
            clearInterval(st);
        }
        //每次移动的跨度
        let span = 5;
        st = setInterval(function () {
            let currentTop = getCurrentTop();
            //当在跨度内时，直接到达
            if (currentTop >= top - span && currentTop <= top + span) {
                setTop(top);
                // $(scroll).scrollTop(top);
                //让st为null，让关闭定时器
                let tmp_st = st;
                st = null;
                //关闭定时器（下一次不会再执行，但本次还会执行下去），再return;
                clearInterval(tmp_st);
                // console.log("滚动完成",top+"<is>"+ getCurrentTop() )
                return;
            }
            //如果不在跨度内时，根据当前的位置与目的位置进行上下移动指定跨度
            if (currentTop < top) {
                setTop(currentTop + span)
            } else {
                setTop(currentTop - span)
            }
            span++
        }, 20)
    }
    function onUrlChange(fun) {
        let initUrl = window.location.href.split("#")[0];
        setInterval(function () {
            let currentUrl =  window.location.href.split("#")[0];
            if(initUrl != currentUrl) {
               // console.log("url改变了")
               fun();
               initUrl = currentUrl;
            }
        },460)
 
    }
 
 
    // 获取url，url经过了处理
    function getCurrentUrl() {
       return window.location.href.split("#")[0]
    }
    function getCurrentPageWhoRoll() {
        return getCurrentUrl()+"<and>WhoRoll";
    }
    function getCurrentTop() {
       return document.documentElement.scrollTop || document.body.scrollTop;
    }
    // 获取文档高度
    function getDocumentHeight() {
       // 获取最大高度
       return (document.documentElement.scrollHeight > document.body.scrollHeight?document.documentElement.scrollHeight:document.body.scrollHeight)
    }
    function setTop(h) {
        let whoRoll = localStorage.getItem(getCurrentPageWhoRoll())
        if(whoRoll == "document") {
            if(document.documentElement.scrollHeight >= h ) {
                document.documentElement.scrollTop = h;
            }
        }else {
            if(document.body.scrollHeight >= h ) {
                document.body.scrollTop = h;
            }
        }
 
 
    }
 
    // 主程序
    function init() {
        // 位置还原
        function recover() {
           // setTop(0)
           setTimeout(function() {
               let item_content = localStorage.getItem(getCurrentUrl())
               if (item_content == null) return;
               // 有滚动记录
               let history_high = parseFloat(item_content);
               let current_height = getDocumentHeight();
               if(history_high != null &&  history_high >= 10 ) {
                   let nearby = parseInt(""+(history_high-80))
                   setTop(nearby);
                   let t = setInterval(function() {
                       // console.log(Math.abs((""+parseInt(getCurrentTop())) - nearby) < 10)
                       if(Math.abs((""+parseInt(getCurrentTop())) - nearby) < 10) {
                           ScrollTo(document,history_high)
                           clearInterval(t);
                       }
                   },200)
               }
           },800)
        }
        recover();
        onUrlChange(recover)
        // 位置保存
         function debounce(fn, wait) {
             var timeout = null;
             return function() {
                 console.log("滚动了")
                 if(timeout != null ) clearTimeout(timeout);
                 timeout= setTimeout (fn, wait);
             }
         }
        // 处理函数
        function handle() {
            console.log(document.documentElement.scrollTop , document.body.scrollTop )
            let current_top = getCurrentTop();
            let current_url = getCurrentUrl()
            if(document.documentElement.scrollTop >  document.body.scrollTop ) {
                localStorage.setItem(getCurrentPageWhoRoll(),"document")
            }else {
                localStorage.setItem(getCurrentPageWhoRoll(),"body")
            }
            console.log("保存位置：",current_url,current_top);
            console.log("滚动责任：",localStorage.getItem(getCurrentPageWhoRoll()));
            if(current_top <= 10) return;
            localStorage.setItem(current_url,""+current_top)
        }
        // 滚动事件
        window.addEventListener('scroll', debounce(handle, 460));
 
    }
 
 
 
 
})();