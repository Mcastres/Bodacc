module Scraper
  class BilanAction
    # rubocop:disable Metrics/MethodLength
    # rubocop:disable Metrics/AbcSize
    def self.create(avis, file, date)
      type_annonce =
        avis.search('typeAnnonce').children.to_s.gsub!(/[^0-9A-Za-z]/, '')
      Bilan.create(
        nojo:
          avis.search('nojo').text,
        type_annonce:
          type_annonce,
        numero_annonce:
          avis.search('numeroAnnonce').text,
        numero_departement:
          avis.search('numeroDepartement').text,
        tribunal:
          avis.search('tribunal').text,
        siren:
          avis.search('numeroIdentificationRCS').text,
        code_rcs:
          avis.search('codeRCS').text,
        nom_greffe_immat:
          avis.search('nomGreffeImmat').text,
        denomination:
          avis.search('denomination').text,
        sigle:
          avis.search('sigle').text,
        forme_juridique:
          avis.search('formeJuridique').text,
        numero_voie:
          avis.search('numeroVoie').text,
        type_voie:
          avis.search('typeVoie').text,
        nom_voie:
          avis.search('nomVoie').text,
        compl_geographique:
          avis.search('complGeographique').text,
        code_postal:
          avis.search('codePostal').text,
        ville:
          avis.search('ville').text,
        date_cloture:
          avis.search('dateCloture').text,
        type_depot:
          avis.search('typeDepot').text,
        descriptif:
          avis.search('descriptif').text,
        nom_publication_ap:
          avis.search('parutionAvisPrecedent/nomPublication').text,
        numero_parution_ap:
          avis.search('parutionAvisPrecedent/numeroParution').text,
        date_parution_ap:
          avis.search('parutionAvisPrecedent/dateParution').text,
        numero_annonce_ap:
          avis.search('parutionAvisPrecedent/numeroAnnonce').text,
        file:
          file.split('/').last,
        type_bodacc:
          'BODACC C',
        annee_parution:
          date,
      )
      return if type_annonce != 'rectificatif'
      rectify(avis.search('parutionAvisPrecedent/numeroAnnonce').text,
              avis.search('numeroIdentificationRCS').text)
    end
    # rubocop:enable Metrics/MethodLength
    # rubocop:enable Metrics/AbcSize

    # Rectify announcements
    def self.rectify(numero_annonce_ap, siren)
      to_delete = Bilan.where(numero_annonce: numero_annonce_ap,
                              type_annonce: 'annonce',
                              siren: siren)
      return if to_delete.empty?
      to_delete.delete_all
      puts "Announcement #{numero_annonce_ap} has been deleted"
    end
  end
end
