
import SwiftUI
import Combine

struct EosImage: View {

    class ViewModel: ObservableObject {

        let urlString: String?

        @Published
        var result: Result<UIImage, Error>? = nil

        var request: AnyCancellable?

        init(urlString: String?) {
            self.urlString = urlString
        }

        func load() {

            request = Just(urlString)
                .setFailureType(to: Error.self)
                .tryMap { urlString in
                    guard let urlString = urlString else {
                        throw SwiftEosAppError.invalidURL
                    }
                    guard let url = URL(string: urlString) else {
                        throw SwiftEosAppError.invalidURL
                    }
                    return url
                }
                .flatMap { (url: URL) -> AnyPublisher<UIImage, Error> in
                    return URLSession.shared.dataTaskPublisher(for: url)
                        .tryMap { data, response -> UIImage in
                            guard let response = response as? HTTPURLResponse else {
                                throw SwiftEosAppError.invalidResponse
                            }
                            guard (200...300).contains(response.statusCode) else {
                                throw SwiftEosAppError.invalidResponse
                            }
                            guard let image = UIImage(data: data) else {
                                throw SwiftEosAppError.invalidImage
                            }
                            return image
                        }
                        .mapError { $0 as Error }
                        .eraseToAnyPublisher()
                }
                .sink { completion in
                    if case let .failure(error) = completion {
                        self.result = .failure(error)
                    }
                } receiveValue: { image in
                    self.result = .success(image)
                }
        }
    }

    @ObservedObject
    var viewModel: ViewModel

    init(_ urlString: String?) {
        self.viewModel = ViewModel(urlString: urlString)
    }

    var body: some View {
        Group {
            if case let .success(uiImage) = viewModel.result {
                Image(uiImage: uiImage)
            } else if case let .failure(error) = viewModel.result {
                KeyValueText("Error:", "\(error)")
                    .foregroundColor(.red)
            } else {
                ProgressView().onAppear { viewModel.load() }
            }
        }
    }
}
