class CreateImmatriculations < ActiveRecord::Migration[5.1]
  def change
    create_table :immatriculations do |t|
      t.string :nojo
      t.string :type_annonce
      t.string :numero_annonce
      t.string :numero_departement
      t.string :tribunal
      t.string :siren
      t.string :code_rcs
      t.string :nom_greffe_immat
      t.string :denomination
      t.string :administration
      t.string :montant_capital
      t.string :devise
      t.string :forme_juridique
      t.string :numero_voie
      t.string :type_voie
      t.string :nom_voie
      t.string :code_postal
      t.string :ville
      t.string :origine_fonds
      t.string :qualite_etablissement
      t.string :activite
      t.datetime :date_immatriculation
      t.datetime :date_commencement_activite
      t.string :descriptif
      t.datetime :date_effet
      t.string :journal
      t.string :opposition
      t.string :declaration_creance
      t.string :categorie
      t.string :immatriculation
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
