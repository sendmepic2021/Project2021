<!-- Description -->
<section id="description" class="card">
    <div class="card-header">
        <h4 class="card-title">Description</h4>
    </div>
    <div class="card-content">
        <div class="card-body">
            <div class="card-text">
                <p>The fixed navbar layout has a fixed navbar and navigation menu and footer. Only navbar section is fixed to user. In this page you can experience it.</p>
            </div>
        </div>
    </div>
</section>
<!--/ Description -->
<!-- CSS Classes -->
<section id="css-classes" class="card">
    <div class="card-header">
        <h4 class="card-title">CSS Classes</h4>
    </div>
    <div class="card-content">
        <div class="card-body">
            <div class="card-text">
                <p>This table contains all classes related to the fixed navbar layout. This is a custom layout classes for fixed navbar layout page requirements.</p>
                <p>All these options can be set via following classes:</p>
                <div class="table-responsive">
                    <table class="table table-hover">
                        <thead>
                            <tr>
                                <th>Classes</th>
                                <th>Description</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <th scope="row"><code>.navbar-sticky</code></th>
                                <td>To set navbar fixed you need to add <code>navbar-sticky</code> class in <code>&lt;body&gt;</code> tag.</td>
                            </tr>
                            <tr>
                                <th scope="row"><code>.fixed-top</code></th>
                                <td>To set navbar fixed you need to add <code>fixed-top</code> class in <code>&lt;nav&gt;</code> tag.</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</section>
<!--/ CSS Classes -->
<!-- HTML Markup -->
<section id="html-markup" class="card">
    <div class="card-header">
        <h4 class="card-title">HTML Markup</h4>
    </div>
    <div class="card-content collapse show">
        <div class="card-body">
            <div class="card-text">
                <p>This section contains HTML Markup to create fixed navbar layout. This markup define where to add css classes to make navbar fixed. Navbar Menu has not spacing between navigation menu and navbar menu.</p>
                <p>Frest has a ready to use starter kit, you can use this layout directly by using the starter kit pages from the <code>frest-clean-bootstrap-admin-dashboard-template/starter-kit</code> folder.</p>
                <pre class="language-html">
        <code class="language-html">
            &lt;!DOCTYPE html&gt;
              &lt;html lang="en"&gt;
                &lt;head&gt;&lt;/head&gt;
                &lt;body class="vertical-layout vertical-menu-modern 2-column navbar-sticky menu-expanded" data-menu="vertical-menu-modern" &gt;

                  &lt;!-- fixed-top--&gt;
                  &lt;nav class="header-navbar navbar-expand-lg navbar navbar-with-menu fixed-top navbar-light navbar-shadow"&gt;
                      ...
                  &lt;/nav&gt;

                  &lt;!-- Begin Navigation--&gt;
                  &lt;div class="main-menu menu-fixed menu-light menu-accordion menu-shadow expanded"&gt;
                      ...
                  &lt;/div&gt;
                  &lt;!-- End Navigation--&gt;

                  &lt;!-- Begin Content--&gt;
                  &lt;div class="app-content content"&gt;
                      .....
                  &lt;/div&gt;
                  &lt;!-- End Content --&gt;

                  &lt;!-- Start Footer light --&gt;
                  &lt;footer class="footer footer-static footer-light"&gt;
                      ...
                  &lt;/footer&gt;
                  &lt;!-- End Footer Light --&gt;

                &lt;/body&gt;
              &lt;/html&gt;
        </code>
        </pre>
            </div>
        </div>
    </div>
</section>
<!--/ HTML Markup -->
