//
//  ArtistViewController.swift
//  Lu
//

import UIKit

final class ArtistViewController: UIViewController {

    private let artistName: String
    private let tracks: [Track]
    private lazy var tableView: UITableView = {
        let t = UITableView(frame: .zero, style: .plain)
        t.backgroundColor = .clear
        t.separatorStyle = .none
        t.register(SongTableViewCell.self, forCellReuseIdentifier: SongTableViewCell.reuseId)
        t.dataSource = self
        t.delegate = self
        t.translatesAutoresizingMaskIntoConstraints = false
        return t
    }()

    init(artistName: String, tracks: [Track]) {
        self.artistName = artistName
        self.tracks = tracks
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = LuminaAppearance.background
        title = artistName

        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        if let nav = navigationController {
            LuminaAppearance.applyDarkNavigationBar(nav.navigationBar)
        }
    }
}

extension ArtistViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tracks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SongTableViewCell.reuseId, for: indexPath) as? SongTableViewCell else {
            return UITableViewCell()
        }
        let track = tracks[indexPath.row]
        cell.configure(track: track, artistTapDelegate: nil)
        cell.setArtistColorMuted(true)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let track = tracks[indexPath.row]
        let playback = PlaybackViewController(initialTrack: track, playlist: tracks)
        navigationController?.pushViewController(playback, animated: true)
    }
}
