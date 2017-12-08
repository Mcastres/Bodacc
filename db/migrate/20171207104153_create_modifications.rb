class CreateModifications < ActiveRecord::Migration[5.1]
  def change
    create_table :modifications do |t|
      t.string :nojo
      t.string :type_annonce
      t.string :numero_annonce
      t.string :numero_departement
      t.string :tribunal
      t.string :siren
      t.string :code_rcs
      t.string :nom_greffe_immat
      t.string :denomination
      t.string :sigle
      t.string :forme_juridique
      t.datetime :date_commencement_activite
      t.datetime :date_effet
      t.string :descriptif
      t.string :denomination_pepm
      t.string :siren_pepm
      t.string :nature_pepp
      t.string :nom_pepp
      t.string :prenom_pepp
      t.string :nom_usage_pepp
      t.string :siren_pepp
      t.string :nom_publication_ap
      t.string :numero_parution_ap
      t.datetime :date_parution_ap
      t.string :numero_annonce_ap
      t.string :file
      t.string :type_bodacc
      t.string :annee_parution
      t.datetime :updated_at
      t.datetime :created_at

      t.timestamps
    end
  end
end
