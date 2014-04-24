# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20140424010419) do

  create_table "accounts", force: true do |t|
    t.text     "username"
    t.text     "password"
    t.datetime "registerdate"
    t.datetime "lastlogin"
    t.text     "ip"
    t.integer  "admin",               limit: 1,          default: 0
    t.integer  "hiddenadmin",         limit: 1,          default: 0
    t.integer  "adminduty",           limit: 1,          default: 0
    t.integer  "adminjail",           limit: 1,          default: 0
    t.integer  "adminjail_time"
    t.text     "adminjail_by"
    t.text     "adminjail_reason"
    t.integer  "banned",              limit: 1,          default: 0
    t.text     "banned_by"
    t.text     "banned_reason"
    t.integer  "muted",               limit: 1,          default: 0
    t.integer  "globalooc",           limit: 1,          default: 1
    t.text     "country"
    t.text     "friendsmessage"
    t.integer  "adminjail_permanent", limit: 1,          default: 0
    t.integer  "adminreports",                           default: 0
    t.integer  "warns",               limit: 1,          default: 0
    t.integer  "chatbubbles",         limit: 1,          default: 1,            null: false
    t.text     "adminnote"
    t.boolean  "appstate",                               default: false
    t.datetime "appdatetime"
    t.text     "appreason",           limit: 2147483647
    t.text     "email"
    t.integer  "help",                                   default: 1,            null: false
    t.integer  "adblocked",                              default: 0,            null: false
    t.integer  "newsblocked",                            default: 0,            null: false
    t.text     "mtaserial"
    t.text     "d_addiction"
    t.string   "loginhash",           limit: 64
    t.integer  "credits",                                default: 0
    t.integer  "transfers",                              default: 0
    t.string   "monitored",                              default: "New Player", null: false
  end

  create_table "adminhistory", force: true do |t|
    t.integer  "user",                  null: false
    t.text     "user_char",             null: false
    t.integer  "admin",                 null: false
    t.text     "admin_char",            null: false
    t.datetime "date",                  null: false
    t.integer  "action",      limit: 1, null: false
    t.integer  "duration",              null: false
    t.text     "reason",                null: false
    t.integer  "hiddenadmin", limit: 1, null: false
  end

  create_table "apb", force: true do |t|
    t.text     "description", null: false
    t.integer  "doneby",      null: false
    t.datetime "time",        null: false
  end

  create_table "applications", force: true do |t|
    t.integer  "accountID",                null: false
    t.datetime "dateposted",               null: false
    t.text     "content",                  null: false
    t.datetime "datereviewed"
    t.integer  "adminID"
    t.text     "adminNote"
    t.integer  "adminAction",  default: 1, null: false
  end

  create_table "atms", force: true do |t|
    t.decimal "x",                   precision: 10, scale: 6, default: 0.0
    t.decimal "y",                   precision: 10, scale: 6, default: 0.0
    t.decimal "z",                   precision: 10, scale: 6, default: 0.0
    t.decimal "rotation",            precision: 10, scale: 6, default: 0.0
    t.integer "dimension",                                    default: 0
    t.integer "interior",                                     default: 0
    t.integer "deposit",   limit: 1,                          default: 0
    t.integer "limit",                                        default: 5000
  end

  create_table "characters", force: true do |t|
    t.text     "charactername"
    t.integer  "account",                      default: 0
    t.float    "x",                            default: 1742.19
    t.float    "y",                            default: -1861.36
    t.float    "z",                            default: 13.5776
    t.float    "rotation",                     default: 0.986053
    t.integer  "interior_id",                  default: 0
    t.integer  "dimension_id",                 default: 0
    t.float    "health",                       default: 100.0
    t.float    "armor",                        default: 0.0
    t.integer  "skin",                         default: 264
    t.integer  "money",              limit: 8, default: 250
    t.integer  "gender",                       default: 0
    t.integer  "cuffed",                       default: 0
    t.integer  "duty",                         default: 0
    t.integer  "cellnumber",                   default: 0
    t.integer  "fightstyle",                   default: 4
    t.integer  "pdjail",                       default: 0
    t.integer  "pdjail_time",                  default: 0
    t.integer  "job",                          default: 0
    t.integer  "cked",                         default: 0
    t.text     "lastarea"
    t.integer  "age",                          default: 18
    t.integer  "faction_id",                   default: -1
    t.integer  "faction_rank",                 default: 1
    t.text     "faction_perks"
    t.integer  "skincolor",                    default: 0
    t.integer  "weight",                       default: 180
    t.integer  "height",                       default: 180
    t.text     "description"
    t.integer  "deaths",                       default: 0
    t.integer  "faction_leader",               default: 0
    t.text     "fingerprint"
    t.integer  "casualskin",                   default: 0
    t.integer  "bankmoney",          limit: 8, default: 500
    t.integer  "car_license",                  default: 0
    t.integer  "gun_license",                  default: 0
    t.integer  "tag",                          default: 1
    t.integer  "hoursplayed",                  default: 0
    t.integer  "pdjail_station",               default: 0
    t.integer  "timeinserver",                 default: 0
    t.integer  "restrainedobj",                default: 0
    t.integer  "restrainedby",                 default: 0
    t.integer  "dutyskin",                     default: -1
    t.integer  "fish",                         default: 0,        null: false
    t.integer  "truckingruns",                 default: 0,        null: false
    t.integer  "truckingwage",                 default: 0,        null: false
    t.integer  "blindfold",          limit: 1, default: 0,        null: false
    t.integer  "lang1",              limit: 1, default: 1
    t.integer  "lang1skill",         limit: 1, default: 100
    t.integer  "lang2",              limit: 1, default: 0
    t.integer  "lang2skill",         limit: 1, default: 0
    t.integer  "lang3",              limit: 1, default: 0
    t.integer  "lang3skill",         limit: 1, default: 0
    t.boolean  "currlang",                     default: true
    t.datetime "lastlogin"
    t.datetime "creationdate",                                    null: false
    t.integer  "election_candidate", limit: 1, default: 0,        null: false
    t.integer  "election_canvote",   limit: 1, default: 0,        null: false
    t.integer  "election_votedfor",            default: 0,        null: false
    t.integer  "jobcontract",        limit: 1, default: 0,        null: false
    t.integer  "marriedto",                    default: 0,        null: false
    t.integer  "photos",                       default: 0,        null: false
    t.integer  "maxvehicles",                  default: 5,        null: false
    t.text     "ck_info"
    t.float    "alcohollevel",                 default: 0.0,      null: false
    t.boolean  "active",                       default: true,     null: false
  end

  create_table "computers", force: true do |t|
    t.float   "posX",      null: false
    t.float   "posY",      null: false
    t.float   "posZ",      null: false
    t.float   "rotX",      null: false
    t.float   "rotY",      null: false
    t.float   "rotZ",      null: false
    t.integer "interior",  null: false
    t.integer "dimension", null: false
    t.integer "model",     null: false
  end

  create_table "dancers", force: true do |t|
    t.float   "x",                   null: false
    t.float   "y",                   null: false
    t.float   "z",                   null: false
    t.float   "rotation",            null: false
    t.integer "skin",      limit: 2, null: false
    t.integer "type",      limit: 1, null: false
    t.integer "interior",            null: false
    t.integer "dimension",           null: false
    t.integer "offset",    limit: 1, null: false
  end

  create_table "don_transaction_failed", force: true do |t|
    t.text   "output",            null: false
    t.string "ip",     limit: 30
  end

  create_table "don_transactions", force: true do |t|
    t.string   "transaction_id",   limit: 64,               null: false
    t.string   "donator_email",                             null: false
    t.float    "amount",                                    null: false
    t.text     "original_request"
    t.datetime "dt",                                        null: false
    t.integer  "handled",          limit: 2,  default: 0
    t.string   "username",         limit: 50,               null: false
    t.float    "realamount",                  default: 0.0, null: false
  end

  create_table "donators", force: true do |t|
    t.integer  "accountID",                               null: false
    t.integer  "charID",                    default: -1,  null: false
    t.integer  "perkID",                                  null: false
    t.string   "perkValue",      limit: 10, default: "1", null: false
    t.datetime "expirationDate",                          null: false
  end

  create_table "elevators", force: true do |t|
    t.decimal "x",                         precision: 10, scale: 6, default: 0.0
    t.decimal "y",                         precision: 10, scale: 6, default: 0.0
    t.decimal "z",                         precision: 10, scale: 6, default: 0.0
    t.decimal "tpx",                       precision: 10, scale: 6, default: 0.0
    t.decimal "tpy",                       precision: 10, scale: 6, default: 0.0
    t.decimal "tpz",                       precision: 10, scale: 6, default: 0.0
    t.integer "dimensionwithin",                                    default: 0
    t.integer "interiorwithin",                                     default: 0
    t.integer "dimension",                                          default: 0
    t.integer "interior",                                           default: 0
    t.integer "car",             limit: 1,                          default: 0
    t.integer "disabled",        limit: 1,                          default: 0
  end

  create_table "emailaccounts", force: true do |t|
    t.text    "username"
    t.text    "password"
    t.integer "creator"
  end

  create_table "emails", force: true do |t|
    t.datetime "date",                 null: false
    t.text     "sender"
    t.text     "receiver"
    t.text     "subject"
    t.text     "message"
    t.integer  "inbox",    default: 0, null: false
    t.integer  "outbox",   default: 0, null: false
  end

  create_table "factions", force: true do |t|
    t.text    "name"
    t.integer "bankbalance", limit: 8
    t.integer "type"
    t.text    "rank_1"
    t.text    "rank_2"
    t.text    "rank_3"
    t.text    "rank_4"
    t.text    "rank_5"
    t.text    "rank_6"
    t.text    "rank_7"
    t.text    "rank_8"
    t.text    "rank_9"
    t.text    "rank_10"
    t.text    "rank_11"
    t.text    "rank_12"
    t.text    "rank_13"
    t.text    "rank_14"
    t.text    "rank_15"
    t.text    "rank_16"
    t.text    "rank_17"
    t.text    "rank_18"
    t.text    "rank_19"
    t.text    "rank_20"
    t.integer "wage_1",                default: 100
    t.integer "wage_2",                default: 100
    t.integer "wage_3",                default: 100
    t.integer "wage_4",                default: 100
    t.integer "wage_5",                default: 100
    t.integer "wage_6",                default: 100
    t.integer "wage_7",                default: 100
    t.integer "wage_8",                default: 100
    t.integer "wage_9",                default: 100
    t.integer "wage_10",               default: 100
    t.integer "wage_11",               default: 100
    t.integer "wage_12",               default: 100
    t.integer "wage_13",               default: 100
    t.integer "wage_14",               default: 100
    t.integer "wage_15",               default: 100
    t.integer "wage_16",               default: 100
    t.integer "wage_17",               default: 100
    t.integer "wage_18",               default: 100
    t.integer "wage_19",               default: 100
    t.integer "wage_20",               default: 100
    t.text    "motd"
    t.text    "note"
  end

  create_table "friends", id: false, force: true do |t|
    t.integer "id",     null: false
    t.integer "friend", null: false
  end

  add_index "friends", ["id", "friend"], name: "index_friends_on_id_and_friend", unique: true, using: :btree

  create_table "fuelpeds", force: true do |t|
    t.float   "posX",                  null: false
    t.float   "posY",                  null: false
    t.float   "posZ",                  null: false
    t.float   "rotZ",                  null: false
    t.integer "skin",                  null: false
    t.integer "priceratio",            null: false
    t.string  "name",       limit: 50, null: false
  end

  create_table "fuelstations", force: true do |t|
    t.decimal "x",         precision: 10, scale: 6, default: 0.0
    t.decimal "y",         precision: 10, scale: 6, default: 0.0
    t.decimal "z",         precision: 10, scale: 6, default: 0.0
    t.integer "interior",                           default: 0
    t.integer "dimension",                          default: 0
  end

  create_table "gates", force: true do |t|
    t.integer "objectID",                         null: false
    t.float   "startX",                           null: false
    t.float   "startY",                           null: false
    t.float   "startZ",                           null: false
    t.float   "startRX",                          null: false
    t.float   "startRY",                          null: false
    t.float   "startRZ",                          null: false
    t.float   "endX",                             null: false
    t.float   "endY",                             null: false
    t.float   "endZ",                             null: false
    t.float   "endRX",                            null: false
    t.float   "endRY",                            null: false
    t.float   "endRZ",                            null: false
    t.integer "gateType",               limit: 1, null: false
    t.integer "autocloseTime",                    null: false
    t.integer "movementTime",                     null: false
    t.integer "objectDimension",                  null: false
    t.integer "objectInterior",                   null: false
    t.text    "gateSecurityParameters"
  end

  create_table "interiors", force: true do |t|
    t.float    "x",                         default: 0.0
    t.float    "y",                         default: 0.0
    t.float    "z",                         default: 0.0
    t.integer  "type",                      default: 0
    t.integer  "owner",                     default: -1
    t.integer  "locked",                    default: 0
    t.integer  "cost",                      default: 0
    t.text     "name"
    t.integer  "interior",                  default: 0
    t.float    "interiorx",                 default: 0.0
    t.float    "interiory",                 default: 0.0
    t.float    "interiorz",                 default: 0.0
    t.integer  "dimensionwithin",           default: 0
    t.integer  "interiorwithin",            default: 0
    t.float    "angle",                     default: 0.0
    t.float    "angleexit",                 default: 0.0
    t.integer  "supplies",                  default: 100
    t.float    "safepositionX"
    t.float    "safepositionY"
    t.float    "safepositionZ"
    t.float    "safepositionRZ"
    t.integer  "fee",                       default: 0
    t.integer  "disabled",        limit: 1, default: 0
    t.datetime "lastused"
  end

  create_table "items", primary_key: "index", force: true do |t|
    t.integer "type",      limit: 1, null: false
    t.integer "owner",               null: false
    t.integer "itemID",              null: false
    t.text    "itemValue",           null: false
  end

  create_table "logtable", force: true do |t|
    t.datetime "time",                null: false
    t.integer  "action",              null: false
    t.string   "source",   limit: 12, null: false
    t.text     "affected",            null: false
    t.text     "content"
  end

  create_table "lottery", id: false, force: true do |t|
    t.integer "characterid",  null: false
    t.integer "ticketnumber", null: false
  end

  create_table "mdcusers", force: true do |t|
    t.string  "user_name",    limit: 20,                 null: false
    t.string  "password",     limit: 20, default: "123", null: false
    t.integer "high_command",            default: 0
  end

  create_table "objects", force: true do |t|
    t.integer "model",                  default: 0,   null: false
    t.float   "posX",                   default: 0.0, null: false
    t.float   "posY",                   default: 0.0, null: false
    t.float   "posZ",                   default: 0.0, null: false
    t.float   "rotX",                   default: 0.0, null: false
    t.float   "rotY",                   default: 0.0, null: false
    t.float   "rotZ",                   default: 0.0, null: false
    t.integer "interior",                             null: false
    t.integer "dimension",                            null: false
    t.string  "comment",     limit: 50
    t.integer "solid",                  default: 1,   null: false
    t.integer "doublesided",            default: 0,   null: false
  end

  create_table "paynspray", force: true do |t|
    t.decimal "x",         precision: 10, scale: 6, default: 0.0
    t.decimal "y",         precision: 10, scale: 6, default: 0.0
    t.decimal "z",         precision: 10, scale: 6, default: 0.0
    t.integer "dimension",                          default: 0
    t.integer "interior",                           default: 0
  end

  create_table "phone_contacts", id: false, force: true do |t|
    t.integer "phone",                  null: false
    t.string  "entryName",   limit: 30, null: false
    t.integer "entryNumber",            null: false
  end

  create_table "phone_settings", primary_key: "phonenumber", force: true do |t|
    t.integer "turnedon",     limit: 2,  default: 1,  null: false
    t.integer "secretnumber", limit: 2,  default: 0,  null: false
    t.integer "ringtone",     limit: 2,  default: 1,  null: false
    t.string  "phonebook",    limit: 40
    t.integer "boughtby",                default: -1, null: false
  end

  create_table "publicphones", force: true do |t|
    t.float   "x",         null: false
    t.float   "y",         null: false
    t.float   "z",         null: false
    t.integer "dimension", null: false
  end

  create_table "settings", force: true do |t|
    t.text "name"
    t.text "value"
  end

  create_table "shops", force: true do |t|
    t.float   "x",                   default: 0.0
    t.float   "y",                   default: 0.0
    t.float   "z",                   default: 0.0
    t.integer "dimension",           default: 0
    t.integer "interior",            default: 0
    t.integer "shoptype",  limit: 1, default: 0
    t.float   "rotation",            default: 0.0, null: false
    t.integer "skin",                default: -1
  end

  create_table "speedcams", force: true do |t|
    t.float   "x",                   default: 0.0, null: false
    t.float   "y",                   default: 0.0, null: false
    t.float   "z",                   default: 0.0, null: false
    t.integer "interior",            default: 0,   null: false
    t.integer "dimension",           default: 0,   null: false
    t.integer "maxspeed",            default: 120, null: false
    t.integer "radius",              default: 2,   null: false
    t.integer "enabled",   limit: 2, default: 1
  end

  create_table "speedingviolations", force: true do |t|
    t.integer  "carID",                    null: false
    t.datetime "time",                     null: false
    t.integer  "speed",                    null: false
    t.string   "area",          limit: 50, null: false
    t.integer  "personVisible",            null: false
  end

  create_table "suspectcrime", force: true do |t|
    t.text    "suspect_name"
    t.text    "time"
    t.text    "date"
    t.text    "officers"
    t.integer "ticket"
    t.integer "arrest"
    t.integer "fine"
    t.text    "ticket_price"
    t.text    "arrest_price"
    t.text    "fine_price"
    t.text    "illegal_items"
    t.text    "details"
    t.text    "done_by"
  end

  create_table "suspectdetails", force: true do |t|
    t.text    "suspect_name"
    t.text    "birth"
    t.text    "gender"
    t.text    "ethnicy"
    t.integer "cell",              default: 0
    t.text    "occupation"
    t.text    "address"
    t.text    "other"
    t.integer "is_wanted",         default: 0
    t.text    "wanted_reason"
    t.text    "wanted_punishment"
    t.text    "wanted_by"
    t.text    "photo"
    t.text    "done_by"
  end

  create_table "tags", force: true do |t|
    t.decimal  "x",            precision: 10, scale: 6
    t.decimal  "y",            precision: 10, scale: 6
    t.decimal  "z",            precision: 10, scale: 6
    t.integer  "interior"
    t.integer  "dimension"
    t.decimal  "rx",           precision: 10, scale: 6
    t.decimal  "ry",           precision: 10, scale: 6
    t.decimal  "rz",           precision: 10, scale: 6
    t.integer  "modelid"
    t.datetime "creationdate"
    t.integer  "creator",                               default: -1, null: false
  end

  create_table "tc_comments", force: true do |t|
    t.integer "poster",             null: false
    t.string  "ip",      limit: 50, null: false
    t.text    "message",            null: false
    t.integer "posted",             null: false
    t.integer "type",               null: false
    t.integer "ticket",             null: false
  end

  create_table "tc_tickets", force: true do |t|
    t.integer "creator",              null: false
    t.integer "posted",               null: false
    t.string  "subject",  limit: 100, null: false
    t.text    "message",              null: false
    t.integer "status",               null: false
    t.integer "lastpost",             null: false
    t.integer "assigned",             null: false
    t.string  "IP",       limit: 50,  null: false
  end

  create_table "tempinteriors", force: true do |t|
    t.float   "posX",     null: false
    t.float   "posY"
    t.float   "posZ"
    t.integer "interior"
  end

  create_table "tempobjects", force: true do |t|
    t.integer "model",                  default: 0,   null: false
    t.float   "posX",                   default: 0.0, null: false
    t.float   "posY",                   default: 0.0, null: false
    t.float   "posZ",                   default: 0.0, null: false
    t.float   "rotX",                   default: 0.0, null: false
    t.float   "rotY",                   default: 0.0, null: false
    t.float   "rotZ",                   default: 0.0, null: false
    t.integer "interior",                             null: false
    t.integer "dimension",                            null: false
    t.string  "comment",     limit: 50
    t.integer "solid",                  default: 1,   null: false
    t.integer "doublesided",            default: 0,   null: false
  end

  create_table "vehicles", force: true do |t|
    t.integer "model",                                               default: 0
    t.decimal "x",                          precision: 10, scale: 6, default: 0.0
    t.decimal "y",                          precision: 10, scale: 6, default: 0.0
    t.decimal "z",                          precision: 10, scale: 6, default: 0.0
    t.decimal "rotx",                       precision: 10, scale: 6, default: 0.0
    t.decimal "roty",                       precision: 10, scale: 6, default: 0.0
    t.decimal "rotz",                       precision: 10, scale: 6, default: 0.0
    t.decimal "currx",                      precision: 10, scale: 6, default: 0.0
    t.decimal "curry",                      precision: 10, scale: 6, default: 0.0
    t.decimal "currz",                      precision: 10, scale: 6, default: 0.0
    t.decimal "currrx",                     precision: 10, scale: 6, default: 0.0
    t.decimal "currry",                     precision: 10, scale: 6, default: 0.0
    t.decimal "currrz",                     precision: 10, scale: 6, default: 0.0,                                                         null: false
    t.integer "fuel",                                                default: 100
    t.integer "engine",                                              default: 0
    t.integer "locked",                                              default: 0
    t.integer "lights",                                              default: 0
    t.integer "sirens",                                              default: 0
    t.integer "paintjob",                                            default: 0
    t.float   "hp",                                                  default: 1000.0
    t.string  "color1",         limit: 50,                           default: "0"
    t.string  "color2",         limit: 50,                           default: "0"
    t.string  "color3",         limit: 50
    t.string  "color4",         limit: 50
    t.text    "plate"
    t.integer "faction",                                             default: -1
    t.integer "owner",                                               default: -1
    t.integer "job",                                                 default: -1
    t.integer "tintedwindows",                                       default: 0
    t.integer "dimension",                                           default: 0
    t.integer "interior",                                            default: 0
    t.integer "currdimension",                                       default: 0
    t.integer "currinterior",                                        default: 0
    t.integer "enginebroke",                                         default: 0
    t.text    "items"
    t.text    "itemvalues"
    t.integer "Impounded",                                           default: 0
    t.integer "handbrake",                                           default: 0
    t.float   "safepositionX"
    t.float   "safepositionY"
    t.float   "safepositionZ"
    t.float   "safepositionRZ"
    t.string  "upgrades",       limit: 150,                          default: "[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]"
    t.string  "wheelStates",    limit: 30,                           default: "[ [ 0, 0, 0, 0 ] ]"
    t.string  "panelStates",    limit: 40,                           default: "[ [ 0, 0, 0, 0, 0, 0, 0 ] ]"
    t.string  "doorStates",     limit: 30,                           default: "[ [ 0, 0, 0, 0, 0, 0 ] ]"
    t.integer "odometer",                                            default: 0
    t.string  "headlights",     limit: 30,                           default: "[ [ 255, 255, 255 ] ]"
    t.integer "variant1",       limit: 3,                            default: 255,                                                         null: false
    t.integer "variant2",       limit: 3,                            default: 255,                                                         null: false
  end

  create_table "wiretransfers", force: true do |t|
    t.integer  "from",   null: false
    t.integer  "to",     null: false
    t.integer  "amount", null: false
    t.text     "reason", null: false
    t.datetime "time",   null: false
    t.integer  "type",   null: false
  end

  create_table "worlditems", force: true do |t|
    t.integer  "itemid",       default: 0
    t.text     "itemvalue"
    t.float    "x",            default: 0.0
    t.float    "y",            default: 0.0
    t.float    "z",            default: 0.0
    t.integer  "dimension",    default: 0
    t.integer  "interior",     default: 0
    t.datetime "creationdate"
    t.float    "rz",           default: 0.0
    t.integer  "creator",      default: 0
    t.integer  "protected",    default: 0,   null: false
  end

end
