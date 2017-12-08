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

ActiveRecord::Schema.define(version: 20171207114120) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bilans", force: :cascade do |t|
    t.string "nojo"
    t.string "type_annonce"
    t.string "numero_annonce"
    t.string "numero_departement"
    t.string "tribunal"
    t.string "siren"
    t.string "code_rcs"
    t.string "nom_greffe_immat"
    t.string "denomination"
    t.string "sigle"
    t.string "forme_juridique"
    t.string "numero_voie"
    t.string "type_voie"
    t.string "nom_voie"
    t.string "compl_geographique"
    t.string "code_postal"
    t.string "ville"
    t.string "date_cloture"
    t.string "type_depot"
    t.string "descriptif"
    t.string "nom_publication_ap"
    t.string "numero_parution_ap"
    t.datetime "date_parution_ap"
    t.string "numero_annonce_ap"
    t.string "file"
    t.string "type_bodacc"
    t.string "annee_parution"
    t.datetime "updated_at", null: false
    t.datetime "created_at", null: false
  end

  create_table "immatriculations", force: :cascade do |t|
    t.string "nojo"
    t.string "type_annonce"
    t.string "numero_annonce"
    t.string "numero_departement"
    t.string "tribunal"
    t.string "siren"
    t.string "code_rcs"
    t.string "nom_greffe_immat"
    t.string "denomination"
    t.string "administration"
    t.string "montant_capital"
    t.string "devise"
    t.string "forme_juridique"
    t.string "numero_voie"
    t.string "type_voie"
    t.string "nom_voie"
    t.string "code_postal"
    t.string "ville"
    t.string "origine_fonds"
    t.string "qualite_etablissement"
    t.string "activite"
    t.datetime "date_immatriculation"
    t.datetime "date_commencement_activite"
    t.string "descriptif"
    t.datetime "date_effet"
    t.string "journal"
    t.string "opposition"
    t.string "declaration_creance"
    t.string "categorie"
    t.string "immatriculation"
    t.string "nom_publication_ap"
    t.string "numero_parution_ap"
    t.datetime "date_parution_ap"
    t.string "numero_annonce_ap"
    t.string "file"
    t.string "type_bodacc"
    t.string "annee_parution"
    t.datetime "updated_at", null: false
    t.datetime "created_at", null: false
  end

  create_table "modifications", force: :cascade do |t|
    t.string "nojo"
    t.string "type_annonce"
    t.string "numero_annonce"
    t.string "numero_departement"
    t.string "tribunal"
    t.string "siren"
    t.string "code_rcs"
    t.string "nom_greffe_immat"
    t.string "denomination"
    t.string "sigle"
    t.string "forme_juridique"
    t.datetime "date_commencement_activite"
    t.datetime "date_effet"
    t.string "descriptif"
    t.string "denomination_pepm"
    t.string "siren_pepm"
    t.string "nature_pepp"
    t.string "nom_pepp"
    t.string "prenom_pepp"
    t.string "nom_usage_pepp"
    t.string "siren_pepp"
    t.string "nom_publication_ap"
    t.string "numero_parution_ap"
    t.datetime "date_parution_ap"
    t.string "numero_annonce_ap"
    t.string "file"
    t.string "type_bodacc"
    t.string "annee_parution"
    t.datetime "updated_at", null: false
    t.datetime "created_at", null: false
  end

  create_table "pcls", force: :cascade do |t|
    t.string "nojo"
    t.string "type_annonce"
    t.string "numero_annonce"
    t.string "numero_departement"
    t.string "tribunal"
    t.string "identifiant_client"
    t.string "siren"
    t.string "code_rcs"
    t.string "nom_greffe_immat"
    t.string "denomination"
    t.string "sigle"
    t.string "forme_juridique"
    t.string "numero_voie"
    t.string "type_voie"
    t.string "nom_voie"
    t.string "compl_geographique"
    t.string "code_postal"
    t.string "ville"
    t.string "famille"
    t.string "nature"
    t.datetime "date_jugement"
    t.string "compl_jugement"
    t.string "nom_publication_ap"
    t.string "numero_parution_ap"
    t.datetime "date_parution_ap"
    t.string "numero_annonce_ap"
    t.string "file"
    t.string "type_bodacc"
    t.string "annee_parution"
    t.datetime "updated_at", null: false
    t.datetime "created_at", null: false
  end

  create_table "radiations", force: :cascade do |t|
    t.string "nojo"
    t.string "type_annonce"
    t.string "numero_annonce"
    t.string "numero_departement"
    t.string "tribunal"
    t.string "siren"
    t.string "code_rcs"
    t.string "nom_greffe_immat"
    t.string "denomination"
    t.string "sigle"
    t.string "forme_juridique"
    t.string "numero_voie"
    t.string "type_voie"
    t.string "nom_voie"
    t.string "code_postal"
    t.string "ville"
    t.string "radiation_pm"
    t.datetime "date_cessation_activite_pp"
    t.string "commentaire"
    t.string "nom_publication_ap"
    t.string "numero_parution_ap"
    t.datetime "date_parution_ap"
    t.string "numero_annonce_ap"
    t.string "file"
    t.string "type_bodacc"
    t.string "annee_parution"
    t.datetime "updated_at", null: false
    t.datetime "created_at", null: false
  end

end
