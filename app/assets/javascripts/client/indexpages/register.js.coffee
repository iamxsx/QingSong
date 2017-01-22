
#= require jquery
#= require jquery.validate
#= require_self

$ ->
  $("input").focus ->
    $(this).parent().addClass("active")

  $("input").blur ->
    $(this).parent().removeClass("active")

  $("#normaluser_regform").validate(
    rules:
      'user[email]':
        required:true
        email: true
      'user[username]':
        required: true
        minlength: 6
      'user[password]':
        required: true
        minlength: 6
      'user[password_confirmation]':
        required: true
        equalTo: "#user_password"
      'user[invite_code]':
        required: true
    messages:
      'user[email]':
        required:"请输入邮箱"
        email: "邮箱格式有误"
      'user[username]':
        required: "请输入姓名"
        minlength: "姓名位数要大于6位"
      'user[password]':
        required: "密码不能为空"
        minlength: "密码位数要大于6位"
      'user[password_confirmation]':
        required: "密码不能为空"
        equalTo: "两次密码输入不一致,请仔细检查"
      'user[invite_code]':
        required: "邀请码不能为空"
    errorPlacement: (error,element) ->
      element.parent().next().html(error)

  )
