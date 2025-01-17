import CoreImage

class CIDifferenceHighlightFilter: CIFilter {
  var inputImage: CIImage?
  var backgroundImage: CIImage?
  var threshold: CGFloat = 0.1

  static let kernel = CIColorKernel(source: """
  kernel vec4 differenceHighlight(__sample pixel1, __sample pixel2, float threshold) {
      // Compute the Euclidean distance between the RGB components
      float diff = distance(pixel1.rgb, pixel2.rgb);
      // If the difference exceeds the threshold, return white; else, return black
      return diff > threshold ? vec4(1.0, 1.0, 1.0, 1.0) : vec4(0.0, 0.0, 0.0, 1.0);
  }
  """)!

  override var outputImage: CIImage? {
    guard let inputImage, let backgroundImage else { return nil }
    return CIDifferenceHighlightFilter.kernel.apply(
      extent: inputImage.extent,
      roiCallback: { _, rect in rect },
      arguments: [inputImage, backgroundImage, threshold]
    )
  }
}
