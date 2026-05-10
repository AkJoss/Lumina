//
//  SongTableViewCell.swift
//  Lu
//

import UIKit

protocol SongTableViewCellDelegate: AnyObject {
    func songCell(_ cell: SongTableViewCell, didTapArtist track: Track)
}

final class SongTableViewCell: UITableViewCell {
    static let reuseId = "SongTableViewCell"

    let cardView = UIView()
    let artworkImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 8
        iv.backgroundColor = .white
        iv.image = UIImage(named: "SongPlaceholder")
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    let titleLabel = UILabel()
    let artistLabel = UILabel()

    weak var delegate: SongTableViewCellDelegate?
    private var track: Track?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .default
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        cardView.backgroundColor = LuminaAppearance.cardBackground
        cardView.layer.cornerRadius = 12
        cardView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(cardView)

        titleLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        titleLabel.textColor = LuminaAppearance.primaryText
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        artistLabel.font = .systemFont(ofSize: 14, weight: .regular)
        artistLabel.textColor = LuminaAppearance.accentGreen
        artistLabel.translatesAutoresizingMaskIntoConstraints = false

        cardView.addSubview(artworkImageView)
        cardView.addSubview(titleLabel)
        cardView.addSubview(artistLabel)

        artistLabel.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(artistTapped))
        artistLabel.addGestureRecognizer(tap)

        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),

            artworkImageView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 14),
            artworkImageView.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            artworkImageView.widthAnchor.constraint(equalToConstant: 52),
            artworkImageView.heightAnchor.constraint(equalToConstant: 52),

            titleLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: artworkImageView.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -14),

            artistLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            artistLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            artistLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            artistLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -12)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(track: Track, artistTapDelegate: SongTableViewCellDelegate? = nil) {
        self.track = track
        self.delegate = artistTapDelegate
        titleLabel.text = track.title
        artistLabel.text = track.artist
        artistLabel.isUserInteractionEnabled = artistTapDelegate != nil
    }

    func setArtistColorMuted(_ muted: Bool) {
        artistLabel.textColor = muted ? LuminaAppearance.secondaryMuted : LuminaAppearance.accentGreen
    }

    @objc private func artistTapped() {
        guard let track else { return }
        delegate?.songCell(self, didTapArtist: track)
    }
}
