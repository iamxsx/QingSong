# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
Rails.application.config.assets.paths << Rails.root.join("public")

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )


Rails.application.config.assets.precompile += %w( jquery )

Rails.application.config.assets.precompile += %w( client/indexpages/index/index )
Rails.application.config.assets.precompile += %w( client/indexpages/index/register )
Rails.application.config.assets.precompile += %w( client/indexpages/register )
Rails.application.config.assets.precompile += %w( client/usercenter/usercenter )
Rails.application.config.assets.precompile += %w( client/usercenter/usercenter.css )
Rails.application.config.assets.precompile += %w( client/usercenter/com_course )
Rails.application.config.assets.precompile += %w( client/usercenter/com_course.css )
Rails.application.config.assets.precompile += %w( client/usercenter/com_employee )
Rails.application.config.assets.precompile += %w( client/usercenter/com_employee.css )
Rails.application.config.assets.precompile += %w( client/usercenter/com_profile )
Rails.application.config.assets.precompile += %w( client/usercenter/com_profile.css )
Rails.application.config.assets.precompile += %w( client/usercenter/emp_course )
Rails.application.config.assets.precompile += %w( client/usercenter/emp_course.css )
Rails.application.config.assets.precompile += %w( client/usercenter/emp_exam )
Rails.application.config.assets.precompile += %w( client/usercenter/emp_exam.css )
Rails.application.config.assets.precompile += %w( client/usercenter/emp_profile )
Rails.application.config.assets.precompile += %w( client/usercenter/emp_profile.css )
Rails.application.config.assets.precompile += %w( client/coursesys/qsdecoder.js )
Rails.application.config.assets.precompile += %w( client/coursesys/qsstyle )