!function(){var e=!1;StackExchange.beginEditEvent={"init":function(){function t(e){if(!a){a=!0;var t,n;if(s)t=i.find("input#post-params").val().split("|"),n={"PostId":parseInt(t[1]),"owner":parseInt(t[0]),"post_type":StackExchange.options.events.postType.question,"is_suggested_edit":!1,"section":StackExchange.options.events.postEditionSection.tags};else{if(t=i.attr("data-post-params"),!t)return;n=JSON.parse(t),n.PostId=parseInt(i.find("input#post-id").val()),n.section=e}StackExchange.options.user.isDeveloper&&(console.log("post.edit_begin event being recorded with params:"),console.log(n)),StackExchange.using("gps",function(){StackExchange.gps.track("post.edit_begin",n)})}}function n(e,n){var a=i.find(e);a.on("keypress",function(e){0===e.which||e.ctrlKey||e.metaKey||e.altKey||t(n)}),a.on("change",function(){t(n)})}if(!e){e=!0;var a=!1,s=!1,i=$("form#edit-tags-form");if(0===i.length?(i=$("form.inline-post"),0===i.length&&(i=$("form.post-form"))):s=!0,!i)return StackExchange.options.user.isDeveloper&&console.error("No form found! No post.edit_begin events will be recorded"),void 0;n("#title",StackExchange.options.events.postEditionSection.title),n("textarea[name='post-text']",StackExchange.options.events.postEditionSection.body),StackExchange.using("tagEditor",function(){n(".tag-editor input[type='text']",StackExchange.options.events.postEditionSection.tags)})}},"cancel":function(){e=!1}}}();