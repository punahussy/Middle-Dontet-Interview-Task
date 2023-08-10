using System.Text;
using System.Text.RegularExpressions;
using AngleSharp;
using AngleSharp.Dom;
using AngleSharp.Html.Dom;
using AngleSharp.Html.Parser;
using Microsoft.Extensions.Options;

namespace SillyProxy.Sillyfyer;

public class DOMSillyfyer
{
    private readonly string _titlePrefix;
    private readonly string _wordsPostfix;
    
    public DOMSillyfyer(IOptions<AppSettings> appSettings)
    {
        _titlePrefix = appSettings.Value.TitlePrefix;
        _wordsPostfix = appSettings.Value.WordsPostfix;
    }

    private async Task ChangeTitle(IHtmlDocument document)
    {
        var titleElement = document.QuerySelector("title");
        if (titleElement != null)
        {
            titleElement.TextContent = $"{_titlePrefix} | {titleElement.TextContent}";
        }   
    }

    private bool IsChangeSafe(IElement element)
    {
        if (element == null) 
            return false;
        return ! (element.LocalName == "style" || element.LocalName == "script");
    }

    private async Task AddPostfix(INode node)
    {
        if (node is IText textNode)
        {
            if (IsChangeSafe(textNode.ParentElement))
            {
                var newText = textNode.TextContent;
                var regex = new Regex(@"\b\w{" + 6 + @"}\b");
                newText = regex.Replace(newText,  match => match.Value + _wordsPostfix);
                textNode.TextContent = newText;     
            }
        }
        else
        {
            foreach (var child in node.ChildNodes)
            {
                await AddPostfix(child);
            }
        }
    }

    public async Task<string> GetModifiedHtml(string html)
    {
        var config = Configuration.Default.WithDefaultLoader();
        var context = BrowsingContext.New(config);
        var parser = context.GetService<IHtmlParser>();

        var document = await parser.ParseDocumentAsync(html);
        
        await ChangeTitle(document);
        await AddPostfix(document);

        var modifiedHtml = document.DocumentElement.OuterHtml;
        return modifiedHtml;

    }
}