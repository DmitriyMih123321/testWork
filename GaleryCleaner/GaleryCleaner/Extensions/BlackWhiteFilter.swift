//
//  BlackWhiteFilter.swift
//  GaleryCleaner
//
//  Created by Dmitriy Mikhaylov on 21.04.2025.
//

import Foundation
import CoreImage

class BlackWhiteFilter: CIFilter
{
    var inputImage : CIImage?


    let thresholdKernel =  CIColorKernel(source:
    "kernel vec4 thresholdFilter(__sample image, __sample threshold)" +
    "{" +
    "   float imageLuma = dot(image.rgb, vec3(0.2126, 0.7152, 0.0722));" +
    "   float thresholdLuma = dot(threshold.rgb, vec3(0.2126, 0.7152, 0.0722));" +

    "   return vec4(vec3(step(thresholdLuma, imageLuma + 0.01)), 1.0);" +
    "}"
    )


    override var outputImage: CIImage!
    {
        guard let inputImage = inputImage,
              let thresholdKernel = thresholdKernel else
        {
            return nil
        }

        let blurred = inputImage.applyingFilter("CIBoxBlur",
                                                parameters: [kCIInputRadiusKey: 9])

        let extent = inputImage.extent
        let arguments = [inputImage, blurred]

        return thresholdKernel.apply(extent: extent, arguments: arguments)
    }
}
