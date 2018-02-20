module Scraper
    # rubocop:disable Metrics/ClassLength
  class ImmatriculationAction
    # rubocop:disable Metrics/MethodLength
    # rubocop:disable Metrics/AbcSize
    def self.create(annonce, file, date, categorie)
      type_annonce =
        annonce.search('typeAnnonce').children.to_s.gsub!(/[^0-9A-Za-z]/, '')
      Immatriculation.create(
        nojo:
          annonce.search('nojo').text,
        type_annonce:
          type_annonce,
        numero_annonce:
          annonce.search('numeroAnnonce').text,
        numero_departement:
          annonce.search('numeroDepartement').text,
        tribunal:
          annonce.search('tribunal').text,
        siren:
          annonce.search('numeroIdentification').text,
        code_rcs:
          annonce.search('codeRCS').text,
        nom_greffe_immat:
          annonce.search('nomGreffeImmat').text,
        denomination:
          annonce.search('denomination').text,
        administration:
          annonce.search('administration').text,
        montant_capital:
          annonce.search('montantCapital').text,
        devise:
          annonce.search('devise').text,
        forme_juridique:
          annonce.search('formeJuridique').text,
        type_voie:
          annonce.search('typeVoie').text,
        numero_voie:
          annonce.search('numeroVoie').text,
        nom_voie:
          annonce.search('nomVoie').text,
        code_postal:
          annonce.search('codePostal').text,
        ville:
          annonce.search('ville').text,
        origine_fonds:
          annonce.search('origineFonds').text,
        qualite_etablissement:
          annonce.search('qualiteEtablissement').text,
        activite:
          annonce.search('activite').text,
        date_commencement_activite:
          annonce.search('dateCommencementActivite').text,
        date_immatriculation:
          annonce.search('dateImmatriculation').text,
        descriptif:
          annonce.search('descriptif').text,
        date_effet:
          annonce.search('dateEffet').text,
        journal:
          annonce.search('journal').text,
        opposition:
          annonce.search('opposition').text,
        declaration_creance:
          annonce.search('declarationCreance').text,
        categorie:
          categorie,
        immatriculation:
          categorie,
        nom_publication_ap:
          annonce.search('parutionAvisPrecedent/nomPublication').text,
        numero_parution_ap:
          annonce.search('parutionAvisPrecedent/numeroPublication').text,
        date_parution_ap:
          annonce.search('parutionAvisPrecedent/dateParution').text,
        numero_annonce_ap:
          annonce.search('parutionAvisPrecedent/numeroAnnonce').text,
        file:
          file.split('/').last,
        type_bodacc:
          'BODACC A',
        annee_parution:
          date,
      )
      return if type_annonce != 'rectificatif'
      rectify(annonce.search('parutionAvisPrecedent/numeroAnnonce').text,
              annonce.search('numeroIdentificationRCS').text)
    end
    # rubocop:enable Metrics/MethodLength
    # rubocop:enable Metrics/AbcSize

    def self.categorie_immat(annonce)
      if annonce.search('categorieVente').present?
        'Vente'
      elsif annonce.search('categorieCreation').present?
        'Creation'
      else
        'Immatriculation'
      end
    end

    # Rectify announcements
    def self.rectify(numero_annonce_ap, siren)
      to_delete = Immatriculation.where(numero_annonce: numero_annonce_ap,
                                        type_annonce: 'annonce',
                                        siren: siren)
      return if to_delete.empty?
      to_delete.delete_all
      puts "Announcement #{numero_annonce_ap} has been deleted"
    end
  end
  # rubocop:enable Metrics/ClassLength
end
