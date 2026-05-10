//
//  PlaybackViewController.swift
//  Lu
//

import UIKit

final class PlaybackViewController: UIViewController {

    private var playlist: [Track]
    private var currentIndex: Int

    private let artworkView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 16
        iv.backgroundColor = .white
        iv.image = UIImage(named: "SongPlaceholder")
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    private let titleLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 22, weight: .bold)
        l.textColor = LuminaAppearance.primaryText
        l.textAlignment = .center
        l.numberOfLines = 2
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let artistLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 16, weight: .regular)
        l.textColor = LuminaAppearance.secondaryMuted
        l.textAlignment = .center
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let elapsedLabel = UILabel()
    private let remainingLabel = UILabel()
    private let progressSlider = UISlider()
    private var playbackTimer: Timer?
    private var progressSeconds: TimeInterval = 0
    private var isPlaying = true

    private let skipBackButton = UIButton(type: .system)
    private let playPauseButton = UIButton(type: .system)
    private let skipForwardButton = UIButton(type: .system)

    init(initialTrack: Track, playlist: [Track]) {
        self.playlist = playlist
        if let idx = playlist.firstIndex(of: initialTrack) {
            self.currentIndex = idx
        } else {
            self.currentIndex = 0
            self.playlist = [initialTrack]
        }
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = LuminaAppearance.background
        title = "Reproducción"

        elapsedLabel.font = .monospacedDigitSystemFont(ofSize: 12, weight: .regular)
        elapsedLabel.textColor = LuminaAppearance.secondaryMuted
        elapsedLabel.translatesAutoresizingMaskIntoConstraints = false

        remainingLabel.font = .monospacedDigitSystemFont(ofSize: 12, weight: .regular)
        remainingLabel.textColor = LuminaAppearance.secondaryMuted
        remainingLabel.textAlignment = .right
        remainingLabel.translatesAutoresizingMaskIntoConstraints = false

        progressSlider.minimumTrackTintColor = LuminaAppearance.secondaryMuted
        progressSlider.maximumTrackTintColor = UIColor(white: 0.35, alpha: 1)
        progressSlider.thumbTintColor = .white
        progressSlider.translatesAutoresizingMaskIntoConstraints = false
        progressSlider.addTarget(self, action: #selector(sliderChanged(_:)), for: .valueChanged)

        configureTransportButtons()

        view.addSubview(artworkView)
        view.addSubview(titleLabel)
        view.addSubview(artistLabel)
        view.addSubview(elapsedLabel)
        view.addSubview(remainingLabel)
        view.addSubview(progressSlider)
        view.addSubview(skipBackButton)
        view.addSubview(playPauseButton)
        view.addSubview(skipForwardButton)

        let guide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            artworkView.topAnchor.constraint(equalTo: guide.topAnchor, constant: 24),
            artworkView.centerXAnchor.constraint(equalTo: guide.centerXAnchor),
            artworkView.widthAnchor.constraint(equalTo: guide.widthAnchor, multiplier: 0.72),
            artworkView.heightAnchor.constraint(equalTo: artworkView.widthAnchor),

            titleLabel.topAnchor.constraint(equalTo: artworkView.bottomAnchor, constant: 28),
            titleLabel.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -24),

            artistLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            artistLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            artistLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

            progressSlider.topAnchor.constraint(equalTo: artistLabel.bottomAnchor, constant: 28),
            progressSlider.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 24),
            progressSlider.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -24),

            elapsedLabel.leadingAnchor.constraint(equalTo: progressSlider.leadingAnchor),
            elapsedLabel.topAnchor.constraint(equalTo: progressSlider.bottomAnchor, constant: 8),

            remainingLabel.centerYAnchor.constraint(equalTo: elapsedLabel.centerYAnchor),
            remainingLabel.trailingAnchor.constraint(equalTo: progressSlider.trailingAnchor),

            playPauseButton.topAnchor.constraint(equalTo: elapsedLabel.bottomAnchor, constant: 28),
            playPauseButton.centerXAnchor.constraint(equalTo: guide.centerXAnchor),

            skipBackButton.centerYAnchor.constraint(equalTo: playPauseButton.centerYAnchor),
            skipBackButton.trailingAnchor.constraint(equalTo: playPauseButton.leadingAnchor, constant: -56),

            skipForwardButton.centerYAnchor.constraint(equalTo: playPauseButton.centerYAnchor),
            skipForwardButton.leadingAnchor.constraint(equalTo: playPauseButton.trailingAnchor, constant: 56)
        ])

        if let nav = navigationController {
            LuminaAppearance.applyDarkNavigationBar(nav.navigationBar)
        }

        applyCurrentTrack(animated: false)
        startPlaybackTimerIfNeeded()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        playbackTimer?.invalidate()
        playbackTimer = nil
    }

    private func configureTransportButtons() {
        let large = UIImage.SymbolConfiguration(pointSize: 36, weight: .regular)
        skipBackButton.setImage(UIImage(systemName: "backward.end.fill", withConfiguration: large), for: .normal)
        skipForwardButton.setImage(UIImage(systemName: "forward.end.fill", withConfiguration: large), for: .normal)
        skipBackButton.tintColor = .white
        skipForwardButton.tintColor = .white
        skipBackButton.translatesAutoresizingMaskIntoConstraints = false
        skipForwardButton.translatesAutoresizingMaskIntoConstraints = false
        playPauseButton.translatesAutoresizingMaskIntoConstraints = false

        skipBackButton.addTarget(self, action: #selector(skipBack), for: .touchUpInside)
        skipForwardButton.addTarget(self, action: #selector(skipForward), for: .touchUpInside)
        playPauseButton.addTarget(self, action: #selector(togglePlayPause), for: .touchUpInside)

        updatePlayPauseButtonImage()
    }

    private func applyCurrentTrack(animated: Bool) {
        let track = playlist[currentIndex]
        titleLabel.text = track.title
        artistLabel.text = track.artist
        progressSeconds = 0
        progressSlider.value = 0
        refreshTimeLabels()
        updatePlayPauseButtonImage()
    }

    private func refreshTimeLabels() {
        let track = playlist[currentIndex]
        let total = track.duration
        elapsedLabel.text = formatTime(progressSeconds)
        let left = max(0, total - progressSeconds)
        remainingLabel.text = "-\(formatTime(left))"
    }

    private func formatTime(_ t: TimeInterval) -> String {
        let m = Int(t) / 60
        let s = Int(t) % 60
        return String(format: "%d:%02d", m, s)
    }

    private func updatePlayPauseButtonImage() {
        let large = UIImage.SymbolConfiguration(pointSize: 40, weight: .regular)
        let name = isPlaying ? "pause.fill" : "play.fill"
        playPauseButton.setImage(UIImage(systemName: name, withConfiguration: large), for: .normal)
        playPauseButton.tintColor = .white
    }

    private func startPlaybackTimerIfNeeded() {
        playbackTimer?.invalidate()
        guard isPlaying else { return }
        playbackTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
            self?.tick()
        }
        RunLoop.main.add(playbackTimer!, forMode: .common)
    }

    private func tick() {
        let track = playlist[currentIndex]
        progressSeconds += 0.5
        if progressSeconds >= track.duration {
            skipForward()
            return
        }
        let r = Float(progressSeconds / track.duration)
        progressSlider.value = r
        refreshTimeLabels()
    }

    @objc private func sliderChanged(_ sender: UISlider) {
        let track = playlist[currentIndex]
        progressSeconds = TimeInterval(sender.value) * track.duration
        refreshTimeLabels()
    }

    @objc private func togglePlayPause() {
        isPlaying.toggle()
        updatePlayPauseButtonImage()
        if isPlaying {
            startPlaybackTimerIfNeeded()
        } else {
            playbackTimer?.invalidate()
            playbackTimer = nil
        }
    }

    @objc private func skipBack() {
        if progressSeconds > 3 {
            progressSeconds = 0
        } else if currentIndex > 0 {
            currentIndex -= 1
            applyCurrentTrack(animated: true)
        } else {
            progressSeconds = 0
        }
        progressSlider.value = Float(progressSeconds / playlist[currentIndex].duration)
        refreshTimeLabels()
        startPlaybackTimerIfNeeded()
    }

    @objc private func skipForward() {
        if currentIndex < playlist.count - 1 {
            currentIndex += 1
            applyCurrentTrack(animated: true)
        } else {
            progressSeconds = 0
            progressSlider.value = 0
            refreshTimeLabels()
        }
        startPlaybackTimerIfNeeded()
    }
}
