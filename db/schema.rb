# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170506103822) do

  create_table "admin_admin_users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "apply_lessons", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "course_sys_name_cn"
    t.string   "course_sys_desc"
    t.string   "course_sys_cover"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  create_table "companies", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "company_name"
    t.text     "company_desc",    limit: 65535
    t.string   "company_logo"
    t.boolean  "activated",                     default: false
    t.datetime "activated_at"
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
    t.string   "company_address"
    t.string   "company_tel"
  end

  create_table "courses", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "course_name"
    t.integer  "sort"
    t.string   "filename"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "lesson_id"
    t.index ["lesson_id"], name: "index_courses_on_lesson_id", using: :btree
  end

  create_table "invitation_codes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "code"
    t.boolean  "used",       default: false
    t.datetime "invited_at"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "company_id"
    t.index ["company_id"], name: "index_invitation_codes_on_company_id", using: :btree
  end

  create_table "lessons", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "lesson_name"
    t.string   "lesson_desc"
    t.string   "lesson_cover"
    t.integer  "company_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.string   "lesson_file_url"
    t.string   "lesson_file_name"
    t.integer  "state"
    t.string   "version"
    t.boolean  "preview"
    t.string   "preview_url"
    t.index ["company_id"], name: "index_lessons_on_company_id", using: :btree
  end

  create_table "roles", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "role_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_courses", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "user_id"
    t.integer  "course_id"
    t.text     "html_file",   limit: 65535
    t.integer  "step"
    t.integer  "action"
    t.integer  "progress",                  default: 0
    t.boolean  "is_finished",               default: false
    t.integer  "score",                     default: 0
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.index ["course_id"], name: "index_user_courses_on_course_id", using: :btree
    t.index ["user_id"], name: "index_user_courses_on_user_id", using: :btree
  end

  create_table "user_lessons", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "user_id"
    t.integer  "lesson_id"
    t.integer  "status"
    t.integer  "score"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["lesson_id"], name: "index_user_lessons_on_lesson_id", using: :btree
    t.index ["user_id"], name: "index_user_lessons_on_user_id", using: :btree
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "username"
    t.string   "email"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.string   "password_digest"
    t.string   "activation_digest"
    t.boolean  "activated",         default: false
    t.datetime "activated_at"
    t.integer  "role_id"
    t.integer  "company_id"
    t.string   "phone"
    t.string   "last_login_time"
    t.index ["company_id"], name: "index_users_on_company_id", using: :btree
    t.index ["role_id"], name: "index_users_on_role_id", using: :btree
  end

  add_foreign_key "courses", "lessons"
  add_foreign_key "invitation_codes", "companies"
  add_foreign_key "lessons", "companies"
  add_foreign_key "users", "companies"
  add_foreign_key "users", "roles"
end
