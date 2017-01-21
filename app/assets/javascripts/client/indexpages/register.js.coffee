
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
      email:
        required:true
        email: true
      name:
        required: true
      password:
        required: true
        minlength: 6
      password_confirm:
        required: true
        equalTo: "#password"
      invitecode:
        required: true
    messages:
      email:
        required:"请输入邮箱"
        email: "邮箱格式有误"
      name:
        required: "请输入姓名"
      password:
        required: "密码不能为空"
        minlength: "密码位数要大于6位"
      password_confirm:
        required: "密码不能为空"
        equalTo: "两次密码输入不一致,请仔细检查"
      invitecode:
        required: "邀请码不能为空"
    errorPlacement: (error,element) ->
      element.parent().next().html(error)

  )
