//
//  PDFCreator.swift
//  HomeAssessment
//
//  Created by Mengoreo on 2020/3/13.
//  Copyright © 2020 Mengoreo. All rights reserved.
//

import PDFKit
// MARK: - Style Configuration
extension UIFont {
    static var pdfCoverHeader = systemFont(ofSize: 43.0, weight: .bold)
    static var pdfCoverDate = boldSystemFont(ofSize: 23)
    static var pdfCoverAuthors = preferredFont(forTextStyle: .subheadline)
    static var pdfCoverCopyrightTitle = UIFont(name: "AcademyEngravedLetPlain", size: 33)!
    static var pdfCoverCopyrightAuthor = UIFont(name: "Papyrus", size: 7)!
    
    static var pdfBodyHeader = preferredFont(forTextStyle: .headline) // 21
    static var pdfBody = preferredFont(forTextStyle: .body) // 56/3
}

class PDFCreator: NSObject {
    let title: String
    let authors: [String]
    let elderCondition: String
    let houseCondition: String
    let problems: [String]
    
    private let contextCreator = "Mengoreo"
    private let contextAuthor = "com.mengoreo.HA"
    private let logo = UIImage(named: "icon") ?? UIImage()
    
    // MARK: - Layout Configuration
    lazy var pageWidth : CGFloat  = {
        return 8.5 * 72.0
    }()

    lazy var pageHeight : CGFloat = {
        return 11 * 72.0
    }()
    lazy var pageRect : CGRect = {
        CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
    }()
    lazy var marginPoint : CGPoint = {
        return CGPoint(x: 20, y: 50)
    }()

    lazy var marginSize : CGSize = {
        return CGSize(width: self.marginPoint.x * 2 , height: self.marginPoint.y * 2)
    }()
    lazy var maxTextBounds: CGSize = {
        return CGSize(width: pageWidth - marginSize.width,
                      height: pageHeight - marginSize.height)
    }()
    lazy var cgContext: CGContext = {
        print("getting cgContext")
        let context = UIGraphicsGetCurrentContext()!
        context.textMatrix = .identity
        // MARK: - flip context
        context.translateBy(x: 0, y: pageHeight)
        context.scaleBy(x: 1, y: -1)
        return context
    }()
    
    init(title: String,
         authors: [String],
         elderCondition: String,
         houseCondition: String,
         problems: [String]) {
        self.title = title
        self.authors = authors
        self.elderCondition = elderCondition
        self.houseCondition = houseCondition
        self.problems = problems
    }

    func prepareData() -> Data {
        // 1
        let pdfMetaData = [
            kCGPDFContextCreator: contextCreator,
            kCGPDFContextAuthor: contextAuthor,
            kCGPDFContextTitle: title
        ]
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]



        // 3
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
        // 4

        let data = renderer.pdfData { (context) in
            // 5
            context.beginPage()
            //      drawPageNumber(1)
            let titleBottom = addCover(title,
                                       font: .pdfCoverHeader)
            let dateBottom = addCover(Date.currentDateString,
                                      font: .pdfCoverDate,
                                      below: titleBottom + 13)
            let authorBottom = addCover(authors.joined(separator: "\n"),
                                        font: .pdfCoverAuthors,
                                        below: dateBottom + 43)

            let imageBottom = addIcon(imageTop: authorBottom + 130.0)

            let authorityBottom = addCover("Home Assessment",
                                           font: .pdfCoverCopyrightTitle,
                                           below: imageBottom + 160)
            _ = addCover("By Mengoreo", font: .pdfCoverCopyrightAuthor, below: authorityBottom)
            // MARK: - Cover Done
            context.beginPage()
            drawPageNumber(1)
            var lastGroup: (Int, CGFloat)
            lastGroup = add("        一、基本状况",
                            font: .pdfBodyHeader,
                            in: context, at: 1)
            lastGroup = add("        " + elderCondition,
                            font: .pdfBody,
                            in: context,
                            at: lastGroup.0,
                            from: lastGroup.1 + 7)

            lastGroup = add("        二、居室基本状况",
                            font: .pdfBodyHeader,
                            in: context,
                            at: lastGroup.0,
                            from: lastGroup.1 + 20)
            lastGroup = add("        " + houseCondition,
                            font: .pdfBody,
                            in: context,
                            at: lastGroup.0,
                            from: lastGroup.1 + 7)
//
            lastGroup = add("        三、存在问题",
                            font: .pdfBodyHeader,
                            in: context,
                            at: lastGroup.0,
                            from: lastGroup.1 + 20)
            for i in problems.indices {
                lastGroup = add("        ◉ " + problems[i],
                                font: .pdfBody,
                                in: context,
                                at: lastGroup.0,
                                from: lastGroup.1 + 7)
            }
            
          
        }

        return data
    }
    func renderPage(_ pageNum: Int, withTextRange currentRange: CFRange, andFramesetter framesetter: CTFramesetter?, from lastPosition: CGFloat = 0) -> (CFRange, CGFloat) {
        
        // MARK: - text height in current page
        let textBounds = CTFramesetterSuggestFrameSizeWithConstraints(framesetter!,
                                                                      currentRange,
                                                                      nil,
                                                                      .init(width: maxTextBounds.width, height: maxTextBounds.height - lastPosition),
                                                                      nil)

        if maxTextBounds.height == lastPosition {
            // not enough space in this page
            // MARK: - reset
            print("reset")
            return (currentRange, 0)
        }
        // MARK: - path where text drawn at
        let framePath = CGMutablePath()
        // MARK: - invisble rect surrounds the text, when drawing the rect will be move to marginPoint
        framePath.addRect(CGRect(origin: .zero, size: textBounds))
        
        // MARK: - text frame
        let frameRef = CTFramesetterCreateFrame(framesetter!, currentRange, framePath, nil)

        // MARK: - move up
        print("move up by", pageHeight - (textBounds.height + lastPosition + marginPoint.y))
        cgContext.translateBy(x: marginPoint.x, y: pageHeight - (textBounds.height + lastPosition + marginPoint.y))
        // MARK: - draw
        CTFrameDraw(frameRef, cgContext)
        // MARK: - move back for next
        cgContext.translateBy(x: -marginPoint.x, y: -pageHeight + (textBounds.height + lastPosition + marginPoint.y))
        
        // MARK: - udpate current range
        var currentRange = currentRange
        currentRange = CTFrameGetVisibleStringRange(frameRef)
        currentRange.location += currentRange.length
        currentRange.length = CFIndex(0)

        // MARK: - updating the succeeding position
        var newPosition = textBounds.height + lastPosition
        if newPosition >= maxTextBounds.height {
            newPosition = 0
        }
        return (currentRange, newPosition)
    }

    func addCover(_ text: String,
           font: UIFont,
           below: CGFloat = 50) -> CGFloat {
        // 2
        let textAttributes: [NSAttributedString.Key: Any] =
          [NSAttributedString.Key.font: font]
        let attributedText = NSAttributedString(string: text, attributes: textAttributes)

        let textSize = attributedText.size()
        // 4
        let textRect = CGRect(x: (pageRect.width - textSize.width) / 2.0,
                                     y: below, width: textSize.width,
                                     height: textSize.height)
        // 5
        attributedText.draw(in: textRect)
        // 6
        return textRect.origin.y + textRect.size.height
    }


    func add(_ text: String,
               font: UIFont,
               in context: UIGraphicsPDFRendererContext,
               at currentPage: Int,
               from lastPosition: CGFloat = 0) -> (Int, CGFloat) {

        let textAttributes: [NSAttributedString.Key: Any] =
          [NSAttributedString.Key.font: font]

        let currentText = CFAttributedStringCreate(nil,
                                                   text as CFString,
                                                   textAttributes as CFDictionary)

        let framesetter = CTFramesetterCreateWithAttributedString(currentText!)
        var currentRange = CFRange(location: 0, length: 0)
        var currentPage = currentPage
        var done = false
        var lastPosition = lastPosition
        print("drawing", text)
        repeat {
            let group = renderPage(currentPage, withTextRange: currentRange, andFramesetter: framesetter, from: lastPosition)
            
            // MARK: - update range and lastPosition
            currentRange = group.0
            lastPosition = group.1
            print("lastPosition in repeat", lastPosition)
            print("range in repeat", currentRange)
            /* If we're at the end of the text, exit the loop. */
            if currentRange.location == CFAttributedStringGetLength(currentText) {
//                print("done draw", text)
                done = true
            } else {
                // else need another page
                print("begin page")
                context.beginPage()
                currentPage += 1
                
                drawPageNumber(currentPage)
                lastPosition = 0
                // MARK: - new Page, reset context for those texts not finished drawing
                cgContext.textMatrix = .identity
                cgContext.translateBy(x: 0, y: pageHeight)
                cgContext.scaleBy(x: 1, y: -1)
            }
          
        } while !done

        return (currentPage, lastPosition)
    }

    func drawPageNumber(_ pageNum: Int) {

        let theFont = UIFont.systemFont(ofSize: 20)

        let pageString = NSMutableAttributedString(string: "\(pageNum)")
        pageString.addAttributes(
        [.font: theFont, .foregroundColor:
          UIColor.secondaryLabel],
        range: NSRange(location: 0,
                       length: pageString.length)
        )

        let pageStringSize =  pageString.size()

        let stringRect = CGRect(x: (pageRect.width - pageStringSize.width) / 2.0,
                              y: pageRect.height - (pageStringSize.height) / 2.0 - 20,
                              width: pageStringSize.width,
                              height: pageStringSize.height)

        pageString.draw(in: stringRect)

    }

    func addIcon(imageTop: CGFloat) -> CGFloat {
        // 1
        let maxHeight = pageRect.height * 0.2
        let maxWidth = pageRect.width * 0.3
        // 2
        let aspectWidth = maxWidth / logo.size.width
        let aspectHeight = maxHeight / logo.size.height
        let aspectRatio = min(aspectWidth, aspectHeight)
        // 3
        let scaledWidth = logo.size.width * aspectRatio
        let scaledHeight = logo.size.height * aspectRatio
        // 4
        let imageX = (pageRect.width - scaledWidth) / 2.0
        let imageRect = CGRect(x: imageX, y: imageTop,
                               width: scaledWidth, height: scaledHeight)
        // 5
        logo.draw(in: imageRect)
        return imageRect.origin.y + imageRect.size.height
    }
    
}
