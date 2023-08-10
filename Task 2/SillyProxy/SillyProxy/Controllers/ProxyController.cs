using System.Text;
using AngleSharp.Html.Parser;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Options;
using SillyProxy.Sillyfyer;

namespace SillyProxy.Controllers;

[ApiController]
[Route("/")]
public class ProxyController : ControllerBase
{
    private readonly IHttpClientFactory _httpClientFactory;
    private readonly DOMSillyfyer _domSillyfyer;
    private readonly IOptions<AppSettings> _appSettings;

    public ProxyController(IHttpClientFactory httpClientFactory, DOMSillyfyer domSillyfyer, 
        IOptions<AppSettings> appSettings)
    {
        _httpClientFactory = httpClientFactory;
        _domSillyfyer = domSillyfyer;
        _appSettings = appSettings;
    }

    [HttpGet]
    public async Task<IActionResult> Index()
    {
        return await ViewViaProxy(_appSettings.Value.StartPage);
    }

    [HttpGet("{*url}")]
    public async Task<IActionResult> ViewViaProxy([FromRoute] string url)
    {
        if (String.IsNullOrEmpty(url))
        {
            url = "";
        }
        try
        {
            var httpClient = _httpClientFactory.CreateClient();
            var fullUrl = GetFullUrl(url);
            var response = await httpClient.GetAsync(fullUrl);

            if (!response.IsSuccessStatusCode)
            {
                return BadRequest("Failed to retrieve the HTML content.");
            }

            var htmlContent = await response.Content.ReadAsStringAsync();
            
            var modifiedHtml = await _domSillyfyer.GetModifiedHtml(htmlContent);

            return Content(modifiedHtml, "text/html", Encoding.Unicode);
        }
        catch (Exception ex)
        {
            return StatusCode(500, $"An error occurred: {ex.Message} \t {ex.InnerException}");
        }
    }

    private Uri GetFullUrl(string url)
    {
        return new Uri(new Uri(_appSettings.Value.BaseUrl), url);
    }
}