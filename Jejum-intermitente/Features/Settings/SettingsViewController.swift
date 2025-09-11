//
//  SettingsViewController.swift
//  Jejum-intermitente
//
//  Created by Marcelo Jesus on 10/09/25.
//

import UIKit
import UniformTypeIdentifiers

final class SettingsViewController: BaseViewController<SettingsView> {
    private let viewModel: SettingsViewModel
    private var rows: [SettingsViewModel.Row] = []

    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        setupBindings()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .always
        contentView.tableView.dataSource = self
        contentView.tableView.delegate = self
        viewModel.onAppear()
    }

    private func setupBindings() {
        viewModel.onStateChange = { [weak self] rows in
            self?.rows = rows
            self?.contentView.tableView.reloadData()
        }
        viewModel.onToast = { [weak self] msg in
            let alert = UIAlertController(title: nil, message: msg, preferredStyle: .alert)
            self?.present(alert, animated: true)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) { alert.dismiss(animated: true) }
        }
        viewModel.onExportReady = { [weak self] data in
            self?.presentShareForJSON(data: data)
        }
    }

    // MARK: - Export
    private func presentShareForJSON(data: Data) {
        let tmpURL = FileManager.default.temporaryDirectory
            .appendingPathComponent("fasting-backup-\(Int(Date().timeIntervalSince1970)).json")
        do {
            try data.write(to: tmpURL)
            let vc = UIActivityViewController(activityItems: [tmpURL], applicationActivities: nil)
            vc.popoverPresentationController?.sourceView = view
            present(vc, animated: true)
        } catch {
            let alert = UIAlertController(title: Strings.Common.error, message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: Strings.Common.ok, style: .default))
            present(alert, animated: true)
        }
    }

    // MARK: - Import
    private func presentImportPicker() {
        let types = [UTType.json]
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: types, asCopy: true)
        picker.allowsMultipleSelection = false
        picker.delegate = self
        present(picker, animated: true)
    }
}

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { rows.count }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch rows[indexPath.row] {
        case .toggle(let title, let isOn, let key):
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingsSwitchCell.reuseId, for: indexPath) as! SettingsSwitchCell
            cell.fill(title: title, isOn: isOn)
            cell.onToggle = { [weak self] isOn in self?.viewModel.toggle(key: key, isOn: isOn) }
            return cell
        case .option(let title, let value, _):
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingsOptionCell.reuseId, for: indexPath) as! SettingsOptionCell
            cell.fill(title: title, value: value)
            return cell
        case .action(let title, _):
            let cell = tableView.dequeueReusableCell(withIdentifier: "ActionCell", for: indexPath)
            var config = UIListContentConfiguration.valueCell()
            config.text = title
            cell.contentConfiguration = config
            cell.accessoryType = .disclosureIndicator
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch rows[indexPath.row] {
        case .option(_, _, let key) where key == "theme":
            presentThemeSheet()
        case .action(_, let key) where key == "export_json":
            viewModel.performAction(key: key)
        case .action(_, let key) where key == "import_json":
            presentImportPicker()
        default:
            break
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - Document Picker
extension SettingsViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let url = urls.first else { return }
        do {
            let data = try Data(contentsOf: url)
            viewModel.importFromJSONData(data) { [weak self] msg in
                self?.viewModel.onToast?(msg)
            }
        } catch {
            viewModel.onToast?(Strings.settings_import_failed)
        }
    }
}
