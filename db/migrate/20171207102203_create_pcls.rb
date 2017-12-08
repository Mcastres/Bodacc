class CreatePcls < ActiveRecord::Migration[5.1]
  def change
    create_table :pcls do |t|
      t.string :nojo
      t.string :type_annonce
      t.string :numero_annonce
      t.string :numero_departement
      t.string :tribunal
      t.string :identifiant_client
      t.string :siren
      t.string :code_rcs
      t.string :nom_greffe_immat
      t.string :denomination
      t.string :sigle
      t.string :forme_juridique
      t.string :numero_voie
      t.string :type_voie
      t.string :nom_voie
      t.string :compl_geographique
      t.string :code_postal
      t.string :ville
      t.string :famille
      t.string :nature
      t.datetime :date_jugement
      t.string :compl_jugement
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
